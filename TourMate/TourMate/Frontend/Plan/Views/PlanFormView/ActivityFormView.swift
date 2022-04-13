//
//  ActivityFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct ActivityFormView: View {
    @ObservedObject var viewModel: ActivityFormViewModel
    @StateObject var searchViewModel: SearchViewModel = ViewModelFactory().getSearchViewModel()

    var body: some View {
        PlanFormView<Activity, Section>(viewModel: viewModel,
                                        startDateHeader: "Start Date",
                                        endDateHeader: "End Date") {

            Section("Location") {
                AddressTextField(title: "Address",
                                 location: $viewModel.location,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
            }
        }
    }
}
