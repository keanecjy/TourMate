//
//  TransportFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct TransportFormView: View {
    @ObservedObject var viewModel: TransportFormViewModel
    @StateObject var searchViewModel: SearchViewModel = ViewModelFactory().getSearchViewModel()

    var body: some View {
        PlanFormView<Transport, Section>(viewModel: viewModel,
                                         startDateHeader: "Departure Date",
                                         endDateHeader: "Arrival Date") {
            Section("Location") {
                AddressTextField(title: "Departure Location",
                                 location: $viewModel.startLocation,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
                AddressTextField(title: "Arrival Location",
                                 location: $viewModel.endLocation,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
            }
        }
    }
}
