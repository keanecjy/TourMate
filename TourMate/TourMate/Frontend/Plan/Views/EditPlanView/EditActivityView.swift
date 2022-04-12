//
//  EditActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct EditActivityView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditActivityViewModel

    var body: some View {
        EditPlanView(viewModel: viewModel, planName: "Activity") {
            PlanFormView(viewModel: viewModel,
                         startDateHeader: "Start Date",
                         endDateHeader: "End Date") {

                Section("Location") {
                    AddressTextField(title: "Address", location: $viewModel.location)
                }
            }
        }
    }
}
