//
//  InviteUserView.swift
//  TourMate
//
//  Created by Terence Ho on 25/3/22.
//

import SwiftUI

// Button style issue:
// https://www.hackingwithswift.com/forums/swiftui/buttons-in-a-form-section/6175
struct InviteUserView: View {
    @ObservedObject var viewModel: TripViewModel
    @State var email = ""

    var body: some View {
        HStack {
            TextField("User's email", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)

            Button("Invite") {
                Task {
                    await viewModel.inviteUser(email: email)
                    email = ""
                }
            }
        }
        // to fix the entire HStack becoming a button
        .buttonStyle(BorderlessButtonStyle())
    }
}

// struct InviteUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        InviteUserView()
//    }
// }
