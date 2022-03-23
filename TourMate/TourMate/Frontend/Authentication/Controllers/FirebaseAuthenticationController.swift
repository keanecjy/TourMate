//
//  FirebaseAuthenticationController.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import Foundation
import FirebaseAuth

// https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/
final class FirebaseAuthenticationController: ObservableObject, AuthenticationController {

    private(set) static var singleton = FirebaseAuthenticationController()

    @Published private(set) var userIsLoggedIn: Bool
    private let authenticationManager: AuthenticationManager = FirebaseAuthenticationManager()
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    private init() {
        self.userIsLoggedIn = false

        authStateListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                self.userIsLoggedIn = true
            } else {
                self.userIsLoggedIn = false
            }
        }
    }

    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    func checkIfUserIsLoggedIn() {
        let hasLoggedInUser = authenticationManager.checkIfUserIsLoggedIn()
        self.userIsLoggedIn = hasLoggedInUser
    }

    func logIn() {
        authenticationManager.logIn()
    }

    func logOut() {
        authenticationManager.logOut()
    }
}
