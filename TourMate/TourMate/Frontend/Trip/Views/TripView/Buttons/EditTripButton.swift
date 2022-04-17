//
//  EditTripButton.swift
//  TourMate
//
//  Created by Keane Chan on 17/4/22.
//

import SwiftUI

struct EditTripButton: View {
    @State private var isShowingEditTripSheet = false

    @ObservedObject var viewModel: TripViewModel

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        Button {
            isShowingEditTripSheet.toggle()
        } label: {
            Image(systemName: "pencil").contentShape(Rectangle())
        }
        .disabled(viewModel.isDeleted || viewModel.isLoading)
        .sheet(isPresented: $isShowingEditTripSheet) {
            EditTripView(viewModel: viewModelFactory.getEditTripViewModel(tripViewModel: viewModel))
        }
    }

}
