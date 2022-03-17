//
//  AuthenticationController.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import Foundation
import FirebaseAuth

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

    func register(email: String, password: String, displayName: String) async
    -> (hasRegistered: Bool, errorMessage: String) {

        guard validateCredentials(email: email, password: password) else {
            return (false, "Email or Password cannot be empty or contain spaces!")
        }

        let (hasRegistered, errorMessage) = await authenticationManager.registerUser(email: email,
                                                                                     password: password)
        guard hasRegistered else {
            return (hasRegistered, errorMessage)
        }

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        let user = User(id: currentUserId, name: displayName, email: email)
        return await userPersistenceController.addUser(user)
    }

    @discardableResult
    func logIn(email: String, password: String) async -> (hasLoggedIn: Bool, errorMessage: String) {

        guard validateCredentials(email: email, password: password) else {
            return (false, "Email or Password cannot be empty or contain spaces!")
        }

        let (hasLoggedIn, errorMessage) = await authenticationManager.logInUser(email: email,
                                                                                password: password)
        return (hasLoggedIn, errorMessage)
    }

    func logOut() async -> (hasLoggedOut: Bool, errorMessage: String) {
        let (hasLoggedOut, errorMessage) = await authenticationManager.logOutUser()
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
}
