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

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
//            LaunchView()
            ContentView()
                .environmentObject(model)
        }
    }
}
