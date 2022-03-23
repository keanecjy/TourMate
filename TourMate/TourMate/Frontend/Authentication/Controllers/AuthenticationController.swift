//
//  AuthenticationController.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation

protocol AuthenticationController: ObservableObject {
    associatedtype ConcreteAuthenticationController: AuthenticationController
    static var singleton: ConcreteAuthenticationController { get }
    var userIsLoggedIn: Bool { get }
    func checkIfUserIsLoggedIn()
    func logIn()
    func logOut()
}
