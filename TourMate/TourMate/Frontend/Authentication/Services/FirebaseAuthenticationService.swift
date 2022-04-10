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

    weak var authDelegate: AuthenticationDelegate?

    @Injected(\.authenticationManager) var authenticationManager: AuthenticationManager

    func fetchLogInStateAndListen() {
        print("[FirebaseAuthenticationService] attaching listener to log in state")
        authenticationManager.firebaseAuthDelegate = self
        authenticationManager.fetchLogInStateAndListen()
    }

    func detachListener() {
        print("[FirebaseAuthenticationService] detaching listener ")
        authenticationManager.firebaseAuthDelegate = nil
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

extension FirebaseAuthenticationService: FirebaseAuthenticationDelegate {
    func update(isLoggedIn: Bool) {
        print("[FirebaseAuthenticationService] Updating log in state: \(isLoggedIn)")
        authDelegate?.update(isLoggedIn: isLoggedIn)
    }
}
