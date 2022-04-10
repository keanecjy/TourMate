//
//  AuthenticationViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 10/4/22.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    static var shared = AuthenticationViewModel()

    @Published var userHasLoggedIn: Bool
    @Injected(\.authenticationService) var authenticationService: AuthenticationService

    private init() {
        userHasLoggedIn = false
    }

    func fetchLogInStateAndListen() {
        print("[AuthenticationViewModel] attaching listener to log in state")
        authenticationService.authDelegate = self
        authenticationService.fetchLogInStateAndListen()
    }

    func detachListener() {
        print("[AuthenticationViewModel] detaching listener")
        authenticationService.authDelegate = nil
        authenticationService.detachListener()
    }

    func logIn() {
        print("[AuthenticationViewModel] Logging In")
        authenticationService.logIn()
    }

    func logOut() {
        print("[AuthenticationViewModel] Logging out")
        authenticationService.logOut()
    }
}

extension AuthenticationViewModel: AuthenticationDelegate {
    func update(isLoggedIn: Bool) {
        print("[AuthenticationViewModel] Updating log in state: \(isLoggedIn)")
        self.userHasLoggedIn = isLoggedIn
    }
}
