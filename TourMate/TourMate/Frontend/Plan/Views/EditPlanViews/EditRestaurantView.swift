//
//  EditRestaurantView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditRestaurantView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = EditPlanViewModel()

    let restaurant: Restaurant

    @State private var isConfirmed = true
    @State private var restaurantName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        self._isConfirmed = State(initialValue: restaurant.status == .confirmed ? true : false)
        self._restaurantName = State(initialValue: restaurant.name)
        self._startDate = State(initialValue: restaurant.startDateTime.date)
        self._endDate = State(initialValue: restaurant.endDateTime.date)
        self._address = State(initialValue: restaurant.startLocation)
        self._phone = State(initialValue: restaurant.phone ?? "")
        self._website = State(initialValue: restaurant.website ?? "")
    }

    private func createUpdatedRestaurant() -> Restaurant {
        let planId = restaurant.id
        let tripId = restaurant.tripId
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = restaurant.creationDate
        let modificationDate = Date()
        let upvotedUserIds = restaurant.upvotedUserIds
        let restaurant = Restaurant(id: planId,
                                    tripId: tripId,
                                    name: restaurantName,
                                    startDateTime: DateTime(date: startDate),
                                    endDateTime: DateTime(date: endDate),
                                    startLocation: address,
                                    status: status,
                                    creationDate: creationDate,
                                    modificationDate: modificationDate,
                                    upvotedUserIds: upvotedUserIds,
                                    phone: phone,
                                    website: website)
        return restaurant
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occured")
                } else {
                    Form {
                        Toggle("Confirmed?", isOn: $isConfirmed)
                        TextField("Restaurant Name", text: $restaurantName)
                        DatePicker("Date",
                                   selection: $startDate,
                                   displayedComponents: [.date, .hourAndMinute])
                        DatePicker("Date",
                                   selection: $endDate,
                                   displayedComponents: [.date, .hourAndMinute])
                        TextField("Address", text: $address)
                        TextField("Phone", text: $phone)
                        TextField("website", text: $website)
                    }
                    .navigationTitle("Edit Restaurant")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                Task {
                                    await viewModel.updatePlan(plan: createUpdatedRestaurant())
                                    dismiss()
                                }
                            }
                            .disabled(viewModel.isLoading || viewModel.hasError)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", role: .destructive) {
                                dismiss()
                            }
                            .disabled(viewModel.isLoading)
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Button("Delete Restaurant", role: .destructive) {
                                Task {
                                    await viewModel.deletePlan(plan: createUpdatedRestaurant())
                                    dismiss()
                                }
                            }
                            .disabled(viewModel.isLoading || viewModel.hasError)
                        }
                    }
                }
            }
        }
    }
}

// struct EditRestaurantView_Previews: PreviewProvider {
//     static var previews: some View {
//        EditRestaurantView()
//    }
// }
