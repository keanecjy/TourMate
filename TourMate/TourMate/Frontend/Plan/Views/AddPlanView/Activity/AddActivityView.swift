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
        AddPlanView(viewModel: viewModel, dismissAddPlanView: dismissAddPlanView) {
            ActivityFormView(viewModel: viewModel, location: $viewModel.location)
        }
    }
}
