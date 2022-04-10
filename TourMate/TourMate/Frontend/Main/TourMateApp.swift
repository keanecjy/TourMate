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
    @Environment(\.scenePhase) var scenePhase
    @StateObject var authenticationViewModel = AuthenticationViewModel.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authenticationViewModel.userHasLoggedIn {
                ContentView()
            } else {
                LaunchView()
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                print("[TourMateApp: Is Active]")
                self.authenticationViewModel.fetchLogInStateAndListen()
            case .inactive:
                print("[TourMateApp: Is Inactive]")
                self.authenticationViewModel.detachListener()
            case .background:
                print("[TourMateApp: Is in Background]")
                self.authenticationViewModel.detachListener()
            @unknown default:
                print("[TourMateApp: Unknown scene phase]")
                self.authenticationViewModel.detachListener()
            }
        }
    }
}
