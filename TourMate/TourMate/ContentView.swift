//
//  ContentView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/3/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: MockModel

    // There is a SwiftUI bug with the NavBar.
    // When you switch between tabs, a space will appear where the nav bar is supposed to be
    // To remove it, I disabled the NavBar for the SettingsView
    var body: some View {
        TabView {
            TripsView()
                .environmentObject(model)
                .tabItem {
                    Label("Trips", systemImage: "paperplane.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .navigationTitle("") // swiftUI bug. we need to set the title
                .navigationBarHidden(true) // before we can hide the navBar
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MockModel())
    }
}
