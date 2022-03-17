//
//  PageStatusDisplay.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct AuthenticationStatusView: View {
    @Binding var warningMessage: String
    @Binding var pageIsDisabled: Bool
    var progressMessage: String

    var body: some View {
        VStack {
            if !warningMessage.isEmpty {
                Text(warningMessage)
                    .foregroundColor(.red)
            }

            if pageIsDisabled {
                ProgressView(progressMessage)
                    .padding()
            }
        }
    }
}

// struct PageStatusDisplay_Previews: PreviewProvider {
//    static var previews: some View {
//        PageStatusDisplay()
//    }
// }
