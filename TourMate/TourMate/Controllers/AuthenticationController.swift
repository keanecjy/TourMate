//
//  AuthenticationController.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

final class AuthenticationController: ObservableObject {

    static let singleton = AuthenticationController()

    @Published var userIsLoggedIn: Bool
    private let authenticationManager: AuthenticationManager = FirebaseAuthenticationManager()
    private let userPersistenceController = UserPersistenceController()

    private init() {
        self.userIsLoggedIn = false
    }

    func checkIfUserIsLoggedIn() async {
        let (user, _) = await userPersistenceController.getUser()
        let hasUser = user != nil
        self.userIsLoggedIn = hasUser
    }

    // TODO: Discuss atomicity
    func register(email: String, password: String, displayName: String) async
    -> (hasRegistered: Bool, errorMessage: String) {

        guard validateCredentials(email: email, password: password) else {
            return (false, "Email or Password cannot be empty or contain spaces!")
        }

        let (hasRegistered, registerErrorMessage) = await authenticationManager.registerUser(email: email,
                                                                                             password: password)
        guard hasRegistered else {
            return (hasRegistered, registerErrorMessage)
        }

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        let user = User(id: currentUserId, name: displayName, email: email)
        let (hasCreatedUser, createUserErrorMessage) = await userPersistenceController.addUser(user)

        if hasCreatedUser {
            self.userIsLoggedIn = true
        }

        return (hasCreatedUser, createUserErrorMessage)
    }

    @discardableResult
    func logIn(email: String, password: String) async -> (hasLoggedIn: Bool, errorMessage: String) {

        guard validateCredentials(email: email, password: password) else {
            return (false, "Email or Password cannot be empty or contain spaces!")
        }

        let (hasLoggedIn, errorMessage) = await authenticationManager.logInUser(email: email,
                                                                                password: password)

        if hasLoggedIn {
            self.userIsLoggedIn = true
        }

        return (hasLoggedIn, errorMessage)
    }

    func logOut() async -> (hasLoggedOut: Bool, errorMessage: String) {
        let (hasLoggedOut, errorMessage) = await authenticationManager.logOutUser()

        if hasLoggedOut {
            self.userIsLoggedIn = false
        }

        return (hasLoggedOut, errorMessage)
    }

    private func validateCredentials(email: String, password: String) -> Bool {
        validateField(email) && validateField(password)
    }

    private func validateField(_ field: String) -> Bool {
        let isNotEmpty = !field.isEmpty
        let notContainsSpaces = field.rangeOfCharacter(from: .whitespacesAndNewlines) == nil

        return isNotEmpty && notContainsSpaces
    }

    // TODO: Abstract responsibilities to AuthenticationManager
    func logInWithGoogle() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                return
            }

            let configuration = GIDConfiguration(clientID: clientID)

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }

            guard let rootViewController = windowScene.windows.first?.rootViewController else {
                return
            }

            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }

    func logOutWIthGoogle() {
        GIDSignIn.sharedInstance.signOut()

        do {
            try Auth.auth().signOut()
            userIsLoggedIn = false
        } catch {
            print(error.localizedDescription)
        }
    }

    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { [self] _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                userIsLoggedIn = true
            }
        }
    }
}
