//
//  TransportFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct TransportFormView: View {
    @ObservedObject var transportFormViewModel: TransportFormViewModel
    @ObservedObject var searchViewModel: SearchViewModel

    var body: some View {
        PlanFormView<Transport, Section>(viewModel: transportFormViewModel,
                                         startDateHeader: "Departure Date",
                                         endDateHeader: "Arrival Date") {
            Section("Location") {
                AddressTextField(title: "Departure Location",
                                 location: $transportFormViewModel.startLocation,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
                AddressTextField(title: "Arrival Location",
                                 location: $transportFormViewModel.endLocation,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
            }
        }
    }
}
