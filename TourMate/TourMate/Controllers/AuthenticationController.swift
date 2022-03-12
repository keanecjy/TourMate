//
//  AuthenticationController.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import Foundation

struct AuthenticationController {
    let authenticationManager: AuthenticationManager = FirebaseAuthenticationManager()

    func logIn(email: String, password: String) {
        print("Received credentials: \(email)")
    }

    func register(email: String, password: String, displayName: String) async
    -> (hasRegistered: Bool, errorMessage: String) {

        let (hasRegistered, errorMessage) = await authenticationManager.registerUser(email: email, password: password)
        return (hasRegistered, errorMessage)
    }
}
