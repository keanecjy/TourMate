//
//  Authenticator.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import Foundation

protocol AuthenticationManager {
    func checkIfUserIsLoggedIn() -> Bool

    // Google Authentication
    func logIn()
    func logOut()
}
