//
//  ContentView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/3/22.
//

import SwiftUI

struct ContentView: View {
    @State var showWarning = false
    @State var warningMessage: String = ""
    @State var hasLoggedOut = false

    var body: some View {
        NavigationView {
            VStack {
                LogOutView(showWarning: $showWarning,
                           warningMessage: $warningMessage,
                           hasLoggedOut: $hasLoggedOut)

                TripsView()

                NavigationLink(isActive: $hasLoggedOut) {
                    LaunchView()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MockModel())
    }
}
