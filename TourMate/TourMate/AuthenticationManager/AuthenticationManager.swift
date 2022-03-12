//
//  Authenticator.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import Foundation

protocol AuthenticationManager {
    func registerUser(email: String, password: String) async -> (hasRegistered: Bool, errorMessage: String)
    func logInUser(email: String, password: String) async -> (hasLoggedIn: Bool, errorMessage: String)
    func logOutUser() async -> (hasLoggedOut: Bool, errorMessage: String)
    func isValidEmail(_ email: String) -> Bool
}
