//
//  EditAccommodationView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditAccommodationView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = EditPlanViewModel()

    let accommodation: Accommodation

    @State private var isConfirmed = true
    @State private var accommodationName = ""
    @State private var checkInDate = Date()
    @State private var checkOutDate = Date()
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    init(accommodation: Accommodation) {
        self.accommodation = accommodation
        self._isConfirmed = State(initialValue: accommodation.status == .confirmed ? true : false)
        self._accommodationName = State(initialValue: accommodation.name)
        self._checkInDate = State(initialValue: accommodation.startDate)
        self._checkOutDate = State(initialValue: accommodation.endDate)
        self._address = State(initialValue: accommodation.address ?? "")
        self._phone = State(initialValue: accommodation.phone ?? "")
        self._website = State(initialValue: accommodation.website ?? "")
    }

    private func createUpdatedAccommodation() -> Accommodation {
        let planId = accommodation.id
        let timeZone = TimeZone.current
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = accommodation.creationDate
        let accommodation = Accommodation(id: planId,
                                          tripId: accommodation.tripId,
                                          name: accommodationName,
                                          startDate: checkInDate,
                                          endDate: checkOutDate,
                                          startTimeZone: timeZone,
                                          status: status,
                                          creationDate: creationDate,
                                          modificationDate: Date(),
                                          address: address,
                                          phone: phone,
                                          website: website)
        return accommodation
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occured")
                } else {
                    Form {
                        Toggle("Confirmed?", isOn: $isConfirmed)
                        TextField("Accommodation Name", text: $accommodationName)
                        DatePicker("Check-in Date",
                                   selection: $checkInDate,
                                   displayedComponents: [.date, .hourAndMinute])
                        DatePicker("Check-out Date",
                                   selection: $checkOutDate,
                                   displayedComponents: [.date, .hourAndMinute])
                        TextField("Address", text: $address)
                        TextField("Phone", text: $phone)
                        TextField("website", text: $website)
                    }
                    .navigationTitle("Edit Accommodation")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                Task {
                                    await viewModel.updatePlan(plan: createUpdatedAccommodation())
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
                            Button("Delete Trip", role: .destructive) {
                                Task {
                                    await viewModel.deletePlan(plan: createUpdatedAccommodation())
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

// struct EditAccommodationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditAccommodationView()
//    }
// }
