//
//  LogOutView.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct LogOutView: View {

    let authenticationController = AuthenticationController.singleton
    let containerSize: CGSize

    @State var warningMessage: String = ""
    @State var isDisabled = false

    var body: some View {
        VStack(alignment: .center) {
            AuthenticationSubmitButton(onPress: onLogOutButtonPressed,
                                       title: "Log Out",
                                       maxWidth: containerSize.width / 5.0,
                                       isDisabled: isDisabled)

            AuthenticationStatusView(warningMessage: $warningMessage,
                                     pageIsDisabled: $isDisabled,
                                     progressMessage: "Logging Out...")
        }

    }

    private func onLogOutButtonPressed() async {
        self.warningMessage = ""
        isDisabled = true

        let (hasLoggedOut, errorMessage) = await authenticationController.logOut()

        isDisabled = false

        if !hasLoggedOut {
            self.warningMessage = errorMessage
        }
    }
}

// struct LogOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogOutView()
//    }
// }
