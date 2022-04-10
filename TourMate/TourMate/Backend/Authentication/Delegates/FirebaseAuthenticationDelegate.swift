//
//  AuthenticationDelegate.swift
//  TourMate
//
//  Created by Terence Ho on 10/4/22.
//

import Foundation

protocol FirebaseAuthenticationDelegate: AnyObject {
    func update(isLoggedIn: Bool)
}
