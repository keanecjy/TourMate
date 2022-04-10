//
//  FirebaseAuthenticationService.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import Foundation
import FirebaseAuth

// https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/
final class FirebaseAuthenticationService: AuthenticationService {

    weak var authServiceDelegate: AuthenticationServiceDelegate?

    @Injected(\.authenticationManager) var authenticationManager: AuthenticationManager

    func getCurrentAuthenticatedUser() -> AuthenticatedUser? {
        authenticationManager.getCurrentAuthenticatedUser()
    }

    func hasLoggedInUser() -> Bool {
        authenticationManager.hasLoggedInUser()
    }

    func fetchLogInStateAndListen() {
        print("[FirebaseAuthenticationService] attaching listener to log in state")
        authenticationManager.authManagerDelegate = self
        authenticationManager.fetchLogInStateAndListen()
    }

    func detachListener() {
        print("[FirebaseAuthenticationService] detaching listener ")
        authenticationManager.authManagerDelegate = nil
        authenticationManager.detachListener()
    }

    func logIn() {
        print("[FirebaseAuthenticationService] logging in")
        authenticationManager.logIn()
    }

    func logOut() {
        print("[FirebaseAuthenticationService] logging out")
        authenticationManager.logOut()
    }
}

extension FirebaseAuthenticationService: AuthenticationManagerDelegate {
    func update(isLoggedIn: Bool) {
        print("[FirebaseAuthenticationService] Updating log in state: \(isLoggedIn)")
        authServiceDelegate?.update(isLoggedIn: isLoggedIn)
    }
}
