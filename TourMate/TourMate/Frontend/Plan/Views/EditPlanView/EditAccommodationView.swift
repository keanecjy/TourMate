//
//  EditAccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct EditAccommodationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditAccommodationViewModel

    var body: some View {
        EditPlanView(viewModel: viewModel, planType: "Accommodation") {
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
