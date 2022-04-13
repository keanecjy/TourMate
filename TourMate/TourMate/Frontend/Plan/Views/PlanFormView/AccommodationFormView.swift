//
//  AccommodationFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct AccommodationFormView: View {
    @ObservedObject var accommodationFormViewModel: AccommodationFormViewModel
    @ObservedObject var searchViewModel: SearchViewModel

    var body: some View {
        PlanFormView<Accommodation, Section>(viewModel: accommodationFormViewModel,
                                             startDateHeader: "Check-in Date",
                                             endDateHeader: "Check-out Date") {

            Section("Location") {
                AddressTextField(title: "Address",
                                 location: $accommodationFormViewModel.location,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
            }
        }
    }
}
