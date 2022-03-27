//
//  RestaurantFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct RestaurantFormView: View {
    @Binding var isActive: Bool
    @StateObject var viewModel: AddPlanFormViewModel<Restaurant>

    var body: some View {
        if !viewModel.canAddPlan {
            Text("Start date must be before end date")
                .font(.caption)
                .foregroundColor(.red)
        }
        Form {
            ConfirmedToggle(status: $viewModel.plan.status)
            TextField("Restaurant Name", text: $viewModel.plan.name)
            DatePicker("Start Date",
                       selection: $viewModel.plan.startDateTime.date,
                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                       displayedComponents: [.date, .hourAndMinute])
            DatePicker("End Date",
                       selection: $viewModel.plan.endDateTime.date,
                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                       displayedComponents: [.date, .hourAndMinute])
            TextField("Address", text: $viewModel.plan.startLocation)
            TextField("Phone", text: $viewModel.plan.phone ?? "")
            TextField("website", text: $viewModel.plan.website ?? "")
        }
        .navigationTitle("Restaurant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await viewModel.addPlan()
                        isActive = false
                    }
                }
                .disabled(!viewModel.canAddPlan || viewModel.isLoading || viewModel.hasError)
            }
        }
    }
}

// struct RestaurantFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantFormView()
//    }
// }
