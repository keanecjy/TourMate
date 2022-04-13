//
//  AccommodationFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct AccommodationFormView: View {
    @ObservedObject var viewModel: AccommodationFormViewModel
    @StateObject var searchViewModel: SearchViewModel = ViewModelFactory().getSearchViewModel()

    var body: some View {
        PlanFormView<Accommodation, Section>(viewModel: viewModel,
                                             startDateHeader: "Check-in Date",
                                             endDateHeader: "Check-out Date") {

            Section("Location") {
                AddressTextField(title: "Address",
                                 location: $viewModel.location,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
            }
        }
    }
}
