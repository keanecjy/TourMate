//
//  TourMateApp.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/3/22.
//

import SwiftUI
import Firebase

@main
struct TourMateApp: App {
    @StateObject private var authenticationService = FirebaseAuthenticationService.singleton

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authenticationService.userIsLoggedIn {
                ContentView()
            } else {
                LaunchView()
                    .onAppear {
                        authenticationService.checkIfUserIsLoggedIn()
                    }
            }
        }
    }
}
