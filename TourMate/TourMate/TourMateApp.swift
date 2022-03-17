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
            NavigationView {
                VStack {
                    LaunchView()

                    if displayProgressBar {
                        ProgressView()
                    }

                    // Because it binds to the controller's state, it will auto-navigate
                    // when user is logged in (via register/log in)
                    // it will auto bring the user back here if the user is logged out
                    NavigationLink(isActive: $authenticationController.userIsLoggedIn) {
                        ContentView()
                            .environmentObject(model)
                            .navigationTitle("") // swiftUI bug. we need to set the title
                            .navigationBarHidden(true) // before we can hide the navBar
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        EmptyView()
                    }
                }
            }
            .navigationViewStyle(.stack)
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
