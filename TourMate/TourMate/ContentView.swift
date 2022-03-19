//
//  ContentView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/3/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: MockModel

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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MockModel())
    }
}
