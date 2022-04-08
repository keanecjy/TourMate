//
//  FirebaseAuthenticationManager.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

// https://peterfriese.dev/posts/firebase-async-calls-swift/
struct FirebaseAuthenticationManager: AuthenticationManager {

    @Injected(\.userService) var userService: UserService

    func checkIfUserIsLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }

    func logIn() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
                authenticateUserWithFirebase(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                print("[FirebaseAuthenticationManager] Unable to get ClientID")
                return
            }

            let configuration = GIDConfiguration(clientID: clientID)

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                print("[FirebaseAuthenticationManager] Unable to get window scene")
                return
            }

            guard let rootViewController = windowScene.windows.first?.rootViewController else {
                print("[FirebaseAuthenticationManager] Unable to get root view controller")
                return
            }

            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [self] user, error in
                authenticateUserWithFirebase(for: user, with: error)
            }
        }
    }

    func logOut() {
        GIDSignIn.sharedInstance.signOut()

        do {
            try Auth.auth().signOut()
        } catch {
            print("[FirebaseAuthenticationManager] Firebase log out failed: \(error.localizedDescription)")
        }
    }

    private func authenticateUserWithFirebase(for user: GIDGoogleUser?, with googleAuthError: Error?) {
        if let error = googleAuthError {
            print("[FirebaseAuthenticationManager] Google authentication failed: \(error.localizedDescription)")
            return
        }

        guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            print("[FirebaseAuthenticationManager] Unable to locate user authentication credentials")
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { authResult, error in

            guard error == nil else {
                let errorMessage = error?.localizedDescription ?? ""
                print("[FirebaseAuthenticationManager] Firebase authentication failed: \(errorMessage)")
                return
            }

            if let result = authResult {

                let user = result.user

                if let name = user.displayName,
                   let email = user.email {

                    // Update imageURL if exists
                    let imageUrl = user.photoURL?.absoluteString ?? ""

                    let newUser = User(id: user.uid, name: name, email: email, imageUrl: imageUrl)

                    Task {
                        let (success, errorMessage) = await userService.addUser(newUser)

                        if !success {
                            print("[FirebaseAuthenticationManager] User creation failed: \(errorMessage)")
                        }
                    }
                }
            }
        }
    }
}
