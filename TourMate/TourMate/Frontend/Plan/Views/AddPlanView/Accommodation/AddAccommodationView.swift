//
//  AddAccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import SwiftUI

struct AddAccommodationView: View {
    @StateObject var viewModel: AddAccommodationViewModel
    var dismissAddPlanView: DismissAction

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        AddPlanView(viewModel: viewModel, dismissAddPlanView: dismissAddPlanView) {
            AccommodationFormView(
                viewModel: viewModel,
                location: $viewModel.location,
                searchViewModel: viewModelFactory.getSearchViewModel(location: viewModel.getTripLocation()))
        }
    }
}
