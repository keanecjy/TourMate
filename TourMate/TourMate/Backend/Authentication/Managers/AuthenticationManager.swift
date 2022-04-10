//
//  Authenticator.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import Foundation

protocol AuthenticationManager {

    var firebaseAuthDelegate: FirebaseAuthenticationDelegate? { get set }

    func fetchLogInStateAndListen()
    func detachListener()

    // Google Authentication
    func logIn()
    func logOut()
}
