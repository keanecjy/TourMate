//
//  HomeNavigationView.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct HomeNavigationView: View {
    @StateObject private var model = MockModel()

    @Binding var isActive: Bool

    var body: some View {
        NavigationLink(isActive: $isActive) {
            // TODO: Update navigation
            ContentView()
                .environmentObject(model)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } label: {
            EmptyView()
        }
    }
}

// struct HomeNavigationView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeNavigationView()
//    }
// }
