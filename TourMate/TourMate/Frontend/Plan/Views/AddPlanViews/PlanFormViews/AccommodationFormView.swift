//
//  AccommodationFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AccommodationFormView: View {
    @Binding var isActive: Bool
    @State var isShowingSearchSheet = false
    @ObservedObject var viewModel: AddPlanFormViewModel<Accommodation>

    var body: some View {
        if !viewModel.canAddPlan {
            Text("Start date must be before end date")
                .font(.caption)
                .foregroundColor(.red)
        }
        Form {
            ConfirmedToggle(status: $viewModel.plan.status)
            TextField("Accommodation Name", text: $viewModel.plan.name)
            DatePicker("Check-in Date",
                       selection: $viewModel.plan.startDateTime.date,
                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                       displayedComponents: [.date, .hourAndMinute])
            DatePicker("Check-out Date",
                       selection: $viewModel.plan.endDateTime.date,
                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                       displayedComponents: [.date, .hourAndMinute])
            AddressTextField("Address", text: Binding<String>(
                get: { viewModel.plan.startLocation?.addressFull ?? "" },
                set: { newValue in
                    viewModel.plan.startLocation?.addressFull = newValue
                }
            ))
            TextField("Phone", text: $viewModel.plan.phone ?? "")
            TextField("website", text: $viewModel.plan.website ?? "")
        }
        .navigationTitle("Accommodation")
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

// struct AccommodationFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockPlanService = MockPlanService()
//        let plansViewModel = PlansViewModel(planService: mockPlanService, tripId: "0")
//        let trip = Trip(id: "0", name: "West Coast Summer",
//                        startDate: Date(timeIntervalSince1970: 1_651_442_400),
//                        endDate: Date(timeIntervalSince1970: 1_651_480_400),
//                        imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
//                        creatorUserId: "0")
//        let tripView = TripView(plansViewModel: plansViewModel, trip: trip)
//        AccommodationFormView(isActive: tripView.$isActive, tripId: tripView.trip.id)
//    }
// }
