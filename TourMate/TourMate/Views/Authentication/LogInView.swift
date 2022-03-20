//
//  LogInView.swift
//  TourMate
//
//  Created by Terence Ho on 18/3/22.
//

import SwiftUI

struct LogInView: View {
    let authenticationController = AuthenticationController.singleton
    let containerSize: CGSize

    @State private var isDisabled = false

    var body: some View {
        VStack(alignment: .center) {
            AuthenticationButton(onPress: onGoogleLogInButtonPressed,
                                 title: "Log In Google",
                                 maxWidth: containerSize.width / 5.0,
                                 isDisabled: isDisabled)
        }
    }

    private func onGoogleLogInButtonPressed() {
        authenticationController.logIn()
    }
}

// struct LogInView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogInView()
//    }
// }
