//
//  AddActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddActivityViewModel
    var dismissAddPlanView: DismissAction

    var body: some View {
        AddPlanView(viewModel: viewModel,
                    dismissAddPlanView: dismissAddPlanView,
                    planType: "Activity") {
            PlanFormView<Activity, Section>(viewModel: viewModel,
                                            startDateHeader: "Start Date",
                                            endDateHeader: "End Date") {

                Section("Location") {
                    AddressTextField(title: "Address", location: $viewModel.location)
                }
            }
        }
    }
}
