//
//  TransportFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct TransportFormView: View {
    @ObservedObject var viewModel: TransportFormViewModel

    var body: some View {
        PlanFormView(viewModel: viewModel) {
            Section("Date & Time") {
                DatePicker("Departure Date",
                           selection: $viewModel.planStartDate,
                           in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                           displayedComponents: [.date, .hourAndMinute])

                DatePicker("Arrival Date",
                           selection: $viewModel.planEndDate,
                           in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                           displayedComponents: [.date, .hourAndMinute])
            }

            Section("Location") {
                AddressTextField(title: "Departure Location", location: $viewModel.startLocation)
                AddressTextField(title: "Arrival Location", location: $viewModel.endLocation)
            }
        }
    }
}
