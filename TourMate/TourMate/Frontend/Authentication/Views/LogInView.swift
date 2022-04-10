//
//  LogInView.swift
//  TourMate
//
//  Created by Terence Ho on 18/3/22.
//

import SwiftUI

struct LogInView: View {
    @StateObject var authenticationViewModel = AuthenticationViewModel.shared
    let containerSize: CGSize

    @State private var isDisabled = false

    var body: some View {
        VStack(alignment: .center) {
            AuthenticationButton(onPress: authenticationViewModel.logIn,
                                 title: "Log In",
                                 maxWidth: containerSize.width / 5.0,
                                 isDisabled: isDisabled)
        }
    }
}

// struct LogInView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogInView()
//    }
// }
