//
//  Authenticator.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import Foundation
import Firebase

protocol AuthenticationManager {

    var authManagerDelegate: AuthenticationManagerDelegate? { get set }

    func getCurrentAuthenticatedUser() -> AuthenticatedUser?
    func hasLoggedInUser() -> Bool

    func fetchLogInStateAndListen()
    func detachListener()

    // Google Authentication
    func logIn()
    func logOut()
}
