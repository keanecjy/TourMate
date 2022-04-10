//
//  LogOutView.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct LogOutView: View {
    @StateObject var authenticationViewModel = AuthenticationViewModel.shared
    let containerSize: CGSize

    @State private var isDisabled = false

    var body: some View {
        VStack(alignment: .center) {
            AuthenticationButton(onPress: authenticationViewModel.logOut,
                                 title: "Log Out",
                                 maxWidth: containerSize.width / 5.0,
                                 isDisabled: isDisabled)
        }
    }
}

// struct LogOutView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogOutView()
//    }
// }
