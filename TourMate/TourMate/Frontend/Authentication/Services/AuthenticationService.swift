//
//  AuthenticationService.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation

protocol AuthenticationService {

    var authServiceDelegate: AuthenticationServiceDelegate? { get set }

    func getCurrentAuthenticatedUser() -> AuthenticatedUser?
    func hasLoggedInUser() -> Bool

    func fetchLogInStateAndListen()
    func detachListener()

    func logIn()
    func logOut()
}
