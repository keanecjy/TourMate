//
//  AddAccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import SwiftUI

struct AddAccommodationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddAccommodationViewModel
    var dismissAddPlanView: DismissAction

    var body: some View {
        GenericAddPlanView(viewModel: viewModel,
                           dismissAddPlanView: dismissAddPlanView,
                           planName: "Accommodation") {
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
