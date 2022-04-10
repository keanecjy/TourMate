//
//  AuthenticationService.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation

protocol AuthenticationService {

    var userIsLoggedIn: Bool { get }
    var authDelegate: AuthenticationDelegate? { get set }

    func fetchLogInStateAndListen()
    func detachListener()

    func logIn()
    func logOut()
}
