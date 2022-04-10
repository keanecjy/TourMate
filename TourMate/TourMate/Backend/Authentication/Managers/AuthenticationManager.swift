//
//  Authenticator.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import Foundation
import Firebase

protocol AuthenticationManager {

    var firebaseAuthDelegate: FirebaseAuthenticationDelegate? { get set }

    func getCurrentFirebaseUser() -> Firebase.User?
    func fetchLogInStateAndListen()
    func detachListener()

    // Google Authentication
    func logIn()
    func logOut()
}
