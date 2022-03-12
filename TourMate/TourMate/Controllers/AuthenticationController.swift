//
//  AuthenticationController.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import Foundation

struct AuthenticationController {
    let authenticationManager: AuthenticationManager = FirebaseAuthenticationManager()

    func register(email: String, password: String, displayName: String) async
    -> (hasRegistered: Bool, errorMessage: String) {

        let (hasRegistered, errorMessage) = await authenticationManager.registerUser(email: email, password: password)
        return (hasRegistered, errorMessage)
    }

    func logIn(email: String, password: String) async -> (hasLoggedIn: Bool, errorMessage: String) {
        let (hasLoggedIn, errorMessage) = await authenticationManager.logInUser(email: email, password: password)
        return (hasLoggedIn, errorMessage)
    }

    func logOut() async -> (hasLoggedOut: Bool, errorMessage: String) {
        let (hasLoggedOut, errorMessage) = await authenticationManager.logOutUser()
        return (hasLoggedOut, errorMessage)
    }
}
