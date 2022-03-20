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
        self._startDate = State(initialValue: restaurant.startDate)
        self._endDate = State(initialValue: restaurant.endDate)
        self._address = State(initialValue: restaurant.address ?? "")
        self._phone = State(initialValue: restaurant.phone ?? "")
        self._website = State(initialValue: restaurant.website ?? "")
    }

    private func createUpdatedRestaurant() -> Restaurant {
        let planId = restaurant.id
        let timeZone = TimeZone.current
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let modificationDate = Date()
        let restaurant = Restaurant(id: planId,
                                    tripId: restaurant.tripId,
                                    name: restaurantName,
                                    startDate: startDate,
                                    endDate: endDate,
                                    startTimeZone: timeZone,
                                    status: status,
                                    creationDate: restaurant.creationDate,
                                    modificationDate: modificationDate,
                                    address: address,
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
