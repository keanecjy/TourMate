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
        self._checkInDate = State(initialValue: accommodation.startDateTime.date)
        self._checkOutDate = State(initialValue: accommodation.endDateTime.date)
        self._address = State(initialValue: accommodation.startLocation)
        self._phone = State(initialValue: accommodation.phone ?? "")
        self._website = State(initialValue: accommodation.website ?? "")
    }

    private func createUpdatedAccommodation() -> Accommodation {
        let planId = accommodation.id
        let tripId = accommodation.tripId
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = accommodation.creationDate
        let accommodation = Accommodation(id: planId,
                                          tripId: tripId,
                                          name: accommodationName,
                                          startDateTime: DateTime(date: checkInDate),
                                          endDateTime: DateTime(date: checkOutDate),
                                          startLocation: address,
                                          status: status,
                                          creationDate: creationDate,
                                          modificationDate: Date(),
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
                            Button("Delete Accommodation", role: .destructive) {
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
