//
//  EditAccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct EditAccommodationView: View {
    @StateObject var viewModel: EditAccommodationViewModel

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        EditPlanView(viewModel: viewModel) {
            AccommodationFormView(
                viewModel: viewModel,
                location: $viewModel.location,
                searchViewModel: viewModelFactory.getSearchViewModel(location: viewModel.getTripLocation()))
        }
    }
}
