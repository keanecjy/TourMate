//
//  FirebaseAuthenticationService.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import Foundation
import FirebaseAuth

// https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/
final class FirebaseAuthenticationService: ObservableObject, AuthenticationService {

    private(set) static var shared = FirebaseAuthenticationService()

    @Published private(set) var userIsLoggedIn: Bool

    @Injected(\.authenticationManager) var authenticationManager: AuthenticationManager

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
