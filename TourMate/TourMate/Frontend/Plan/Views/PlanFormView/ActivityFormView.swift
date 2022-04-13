//
//  ActivityFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct ActivityFormView: View {
    @ObservedObject var activityFormViewModel: ActivityFormViewModel
    @ObservedObject var searchViewModel: SearchViewModel

    var body: some View {
        PlanFormView<Activity, Section>(viewModel: activityFormViewModel,
                                        startDateHeader: "Start Date",
                                        endDateHeader: "End Date") {

            Section("Location") {
                AddressTextField(title: "Address",
                                 location: $activityFormViewModel.location,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
            }
        }
    }
}
