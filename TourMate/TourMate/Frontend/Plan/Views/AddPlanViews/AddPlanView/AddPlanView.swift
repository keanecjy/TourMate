//
//  PlanFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AddPlanView: View {
    @Binding var isActive: Bool
    @State var isShowingSearchSheet = false
    @StateObject var viewModel: AddPlanViewModel

    init(isActive: Binding<Bool>, trip: Trip) {
        self._isActive = isActive
        self._viewModel = StateObject(wrappedValue: AddPlanViewModel(trip: trip))
    }

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
            TextField("Start Location", text: $viewModel.plan.startLocation)
                .sheet(isPresented: $isShowingSearchSheet) {
                    SearchView(viewModel: SearchViewModel(), planAddress: $viewModel.plan.startLocation)
                }
                .onTapGesture {
                    isShowingSearchSheet.toggle()
                }
            // TODO: Add End Location
            // TODO: Add Additional Info box
        }
        .navigationTitle("Plan")
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

// struct PlanFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanFormView()
//    }
// }
