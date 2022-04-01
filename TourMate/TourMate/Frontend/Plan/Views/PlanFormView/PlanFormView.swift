//
//  PlanFormView.swift
//  TourMate
//
//  Created by Terence Ho on 1/4/22.
//

import SwiftUI

struct PlanFormView: View {

    @ObservedObject var viewModel: PlanFormViewModel

    var body: some View {
        Form {
            ConfirmedToggle(status: $viewModel.planStatus)

            TextField("Event Name", text: $viewModel.planName)

            DatePicker("Start Date",
                       selection: $viewModel.planStartDate,
                       in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                       displayedComponents: [.date, .hourAndMinute])

            DatePicker("End Date",
                       selection: $viewModel.planEndDate,
                       in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                       displayedComponents: [.date, .hourAndMinute])

            AddressTextField(title: "Start Location", location: $viewModel.planStartLocation)

            AddressTextField(title: "End Location", location: $viewModel.planEndLocation)

            TextField("Image URL", text: $viewModel.planImageUrl)

            Section("Additional Notes") {
                ZStack {
                    // https://stackoverflow.com/questions/62620613/dynamic-row-hight-containing-texteditor-inside-a-list-in-swiftui
                    TextEditor(text: $viewModel.planAdditionalInfo)
                    Text(viewModel.planAdditionalInfo).opacity(0)  // temp fix for dynamic TextEditor
                }

            }
        }
    }
}

// struct PlanFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanFormView()
//    }
// }
