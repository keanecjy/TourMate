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

                    AuthenticationSubmitButton(onPress: onGoogleLogInButtonPressed,
                                               title: "Log In Google",
                                               maxWidth: geometry.size.width / 5.0,
                                               isDisabled: false)

                    NavigationLink {
                        AuthenticationView(authType: .logIn)
                    } label: {
                        LogInTitleView(maxWidth: geometry.size.width / 5.0)
                    }

                    NavigationLink {
                        AuthenticationView(authType: .register)
                    } label: {
                        RegisterTitleView()
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .navigationViewStyle(.stack)
    }

    private func onGoogleLogInButtonPressed() {
        AuthenticationController.singleton.logInWithGoogle()
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
