//
//  LogOutView.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct LogOutView: View {
    let authenticationController = AuthenticationController()

    @Binding var showWarning: Bool
    @Binding var warningMessage: String

    @Binding var hasLoggedOut: Bool

    var body: some View {
        Button {
            Task {
                await onLogOutButtonPressed()
            }
        } label: {
            Text("Log Out")
                .foregroundColor(.blue)
        }
    }

    private func onLogOutButtonPressed() async {
        let (hasLoggedOut, errorMessage) = await authenticationController.logOut()

        self.warningMessage = ""
        self.showWarning = false

        guard hasLoggedOut else {
            self.warningMessage = errorMessage
            self.showWarning = true
            return
        }

        self.hasLoggedOut = true
    }
}

// struct LogOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogOutView()
//    }
// }
