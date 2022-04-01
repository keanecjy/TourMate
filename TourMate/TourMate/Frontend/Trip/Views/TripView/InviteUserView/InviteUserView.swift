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
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: TripViewModel

    init(tripViewModel: TripViewModel) {
        self._viewModel = StateObject(wrappedValue: TripViewModel(tripViewModel))
    }

    @State var email = ""

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    Form {
                        TextField("User's email", text: $email)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)

                        Button {
                            Task {
                                await viewModel.inviteUser(email: email)
                                email = ""
                            }
                        } label: {
                            Text("Invite")
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .navigationTitle("Invite User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
    }
}

// struct InviteUserView_Previews: PreviewProvider {
//    static var previews: some View {
//        InviteUserView()
//    }
// }
