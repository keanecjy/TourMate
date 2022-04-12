//
//  AddActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct AddActivityView: View {
    @StateObject var viewModel: AddActivityViewModel
    var dismissAddPlanView: DismissAction

    var body: some View {
        AddPlanView(viewModel: viewModel,
                    dismissAddPlanView: dismissAddPlanView,
                    planType: "Activity") {
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
