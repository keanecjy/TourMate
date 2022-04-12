//
//  EditTransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct EditTransportView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditTransportViewModel

    var body: some View {
        EditPlanView(viewModel: viewModel, planType: "Transport") {
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
