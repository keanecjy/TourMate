//
//  LogOutView.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct LogOutView: View {
    let authenticationController = FirebaseAuthenticationController.singleton
    let containerSize: CGSize

    @State private var isDisabled = false

    var body: some View {
        VStack(alignment: .center) {
            AuthenticationButton(onPress: onGoogleLogoutButtonPressed,
                                 title: "Log Out Google",
                                 maxWidth: containerSize.width / 5.0,
                                 isDisabled: isDisabled)
        }
    }

    private func onGoogleLogoutButtonPressed() {
        authenticationController.logOut()
    }
}

// struct LogOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogOutView()
//    }
// }
