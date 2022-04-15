//
//  ActivityFormView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct ActivityFormView: View {
    @ObservedObject var viewModel: PlanFormViewModel<Activity>
    @Binding var location: Location
    @StateObject var searchViewModel: SearchViewModel

    var body: some View {
        PlanFormView<Activity, Section>(viewModel: viewModel,
                                        startDateHeader: "Start Date",
                                        endDateHeader: "End Date") {

            Section("Location") {
                AddressTextField(title: "Address",
                                 location: $location,
                                 viewModel: searchViewModel,
                                 query: $searchViewModel.locationQuery)
            }
        }
    }
}
