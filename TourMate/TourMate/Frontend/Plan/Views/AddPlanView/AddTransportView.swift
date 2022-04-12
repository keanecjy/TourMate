//
//  AddTransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct AddTransportView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddTransportViewModel
    var dismissAddPlanView: DismissAction

    var body: some View {
        AddPlanView(viewModel: viewModel,
                    dismissAddPlanView: dismissAddPlanView,
                    planType: "Transport") {
            PlanFormView(viewModel: viewModel,
                         startDateHeader: "Departure Date",
                         endDateHeader: "Arrival Date") {

                Section("Location") {
                    AddressTextField(title: "Departure Location", location: $viewModel.startLocation)
                    AddressTextField(title: "Arrival Location", location: $viewModel.endLocation)
                }
            }
        }
    }
}
