//
//  AuthenticationController.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import Foundation

struct AuthenticationController {
    func logIn(email: String, password: String) {
        print("Received credentials: \(email)")
    }

    func register(email: String, password: String, displayName: String) {
        print("Received credentials: \(email)")
    }
}
