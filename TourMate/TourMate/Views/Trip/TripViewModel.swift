//
//  TripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation

@MainActor
class TripViewModel: ObservableObject {
    @Published var trip: Trip
    @Published private(set) var isLoading: Bool
    @Published private(set) var isDeleted: Bool
    @Published private(set) var hasError: Bool
    let tripController: TripController

    init(trip: Trip, tripController: TripController = FirebaseTripController()) {
        self.trip = trip
        self.isLoading = false
        self.isDeleted = false
        self.hasError = false
        self.tripController = tripController
    }

    func fetchTrip() async {
        self.isLoading = true
        let (trip, errorMessage) = await tripController.fetchTrip(withTripId: trip.id)
        guard let trip = trip, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.trip = trip
        self.isLoading = false
    }

    func updateTrip() async {
        self.isLoading = true
        let (hasUpdated, errorMessage) = await tripController.updateTrip(trip: trip)
        guard hasUpdated, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

    func deleteTrip() async {
        self.isLoading = true
        let (hasDeleted, errorMessage) = await tripController.deleteTrip(trip: trip)
        guard hasDeleted, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isDeleted = true
        self.isLoading = false
    }
}
