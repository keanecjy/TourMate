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

    var body: some View {
        AddPlanView(viewModel: viewModel,
                    dismissAddPlanView: dismissAddPlanView,
                    planType: "Accommodation") {
            PlanFormView(viewModel: viewModel,
                         startDateHeader: "Check-in Date",
                         endDateHeader: "Check-out Date") {

                Section("Location") {
                    AddressTextField(title: "Address", location: $viewModel.location)
                }
            }
        }
    }
}
