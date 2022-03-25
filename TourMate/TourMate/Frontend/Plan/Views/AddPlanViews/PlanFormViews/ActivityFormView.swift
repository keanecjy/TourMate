//
//  ActivityFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct ActivityFormView: View {
    @Binding var isActive: Bool
    @StateObject var viewModel: AddPlanFormViewModel<Activity>

    var body: some View {
        Form {
            Toggle("Confirmed?", isOn: Binding<Bool>(
                get: { viewModel.plan.status == PlanStatus.confirmed },
                set: { select in
                    if select {
                        viewModel.plan.status = PlanStatus.confirmed
                    } else {
                        viewModel.plan.status = PlanStatus.proposed
                    }
                })
            )
            TextField("Event Name", text: $viewModel.plan.name)
            DatePicker("Start Date",
                       selection: $viewModel.plan.startDateTime.date,
                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                       displayedComponents: [.date, .hourAndMinute])
            DatePicker("End Date",
                       selection: $viewModel.plan.endDateTime.date,
                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                       displayedComponents: [.date, .hourAndMinute])
            TextField("Venue", text: $viewModel.plan.venue ?? "")
            TextField("Address", text: $viewModel.plan.startLocation)
            TextField("Phone", text: $viewModel.plan.phone ?? "")
            TextField("Website", text: $viewModel.plan.website ?? "")
        }
        .navigationTitle("Activity")
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

// struct ActivityFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityFormView()
//    }
// }
