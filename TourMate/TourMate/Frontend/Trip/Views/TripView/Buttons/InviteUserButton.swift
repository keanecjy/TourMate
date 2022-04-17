//
//  InviteUserButton.swift
//  TourMate
//
//  Created by Keane Chan on 17/4/22.
//

import SwiftUI

struct InviteUserButton: View {
    @State private var isShowingInviteUsersSheet = false

    @ObservedObject var viewModel: TripViewModel

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        Button {
            isShowingInviteUsersSheet.toggle()
        } label: {
            Image(systemName: "person.crop.circle.badge.plus")
        }
        .disabled(viewModel.isDeleted || viewModel.isLoading)
        .sheet(isPresented: $isShowingInviteUsersSheet) {
            InviteUserView(viewModel: viewModelFactory.copyTripViewModel(tripViewModel: viewModel))
        }
    }
}
