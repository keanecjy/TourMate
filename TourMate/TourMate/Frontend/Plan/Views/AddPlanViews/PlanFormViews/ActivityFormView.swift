//
//  ActivityFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct ActivityFormView: View {
    @Binding var isActive: Bool
    @State var isShowingSearchSheet = false
    @StateObject var viewModel: AddPlanFormViewModel<Activity>

    var body: some View {
        if !viewModel.canAddPlan {
            Text("Start date must be before end date")
                .font(.caption)
                .foregroundColor(.red)
        }
        Form {
            ConfirmedToggle(status: $viewModel.plan.status)
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
            AddressTextField("Address", text: Binding<String>(
                get: { viewModel.plan.startLocation?.addressFull ?? "" },
                set: { newValue in
                    viewModel.plan.startLocation?.addressFull = newValue
                }
            ))
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
