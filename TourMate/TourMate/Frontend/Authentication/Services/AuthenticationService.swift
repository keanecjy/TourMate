//
//  AuthenticationService.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation

protocol AuthenticationService: ObservableObject {
    associatedtype ConcreteAuthenticationService: AuthenticationService
    static var shared: ConcreteAuthenticationService { get }
    var userIsLoggedIn: Bool { get }
    func checkIfUserIsLoggedIn()
    func logIn()
    func logOut()
}
