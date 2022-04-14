//
//  EditTransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct EditTransportView: View {
    @StateObject var viewModel: EditTransportViewModel

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        EditPlanView(viewModel: viewModel) {
            TransportFormView(
                viewModel: viewModel,
                startLocation: $viewModel.startLocation,
                endLocation: $viewModel.endLocation,
                searchViewModel: viewModelFactory.getSearchViewModel(location: viewModel.getTripLocation()))
        }
    }
}
