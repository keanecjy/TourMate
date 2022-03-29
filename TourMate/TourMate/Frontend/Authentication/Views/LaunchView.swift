//
//  LaunchView.swift
//  TourMate
//
//  Created by Terence Ho on 8/3/22.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Spacer()

                    TourMateTitleView()

                    Spacer()

                    LogInView(containerSize: geometry.size)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .navigationViewStyle(.stack)
    }

    private func onGoogleLogInButtonPressed() {
        FirebaseAuthenticationService.singleton.logIn()
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
