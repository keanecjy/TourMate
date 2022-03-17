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
    @StateObject private var model = MockModel()
    @StateObject private var authenticationController = AuthenticationController.singleton

    @State private var displayProgressBar = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authenticationController.userIsLoggedIn {
                ContentView()
                    .environmentObject(model)
            } else {
                    LaunchView()
                    .onAppear {
                        Task {
                            displayProgressBar = true
                            await authenticationController.checkIfUserIsLoggedIn()
                            displayProgressBar = false
                        }
                    }
            }
        }
    }
}
