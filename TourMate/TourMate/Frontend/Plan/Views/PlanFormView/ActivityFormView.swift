//
//  ActivityFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct ActivityFormView: View {
    @ObservedObject var viewModel: ActivityFormViewModel

    var body: some View {
        PlanFormView(viewModel: viewModel) {
            Section("Date & Time") {
                DatePicker("Start Date",
                           selection: $viewModel.planStartDate,
                           in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                           displayedComponents: [.date, .hourAndMinute])

                DatePicker("End Date",
                           selection: $viewModel.planEndDate,
                           in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                           displayedComponents: [.date, .hourAndMinute])
            }

            Section("Location") {
                AddressTextField(title: "Address", location: $viewModel.location)
            }
        }
    }
}
