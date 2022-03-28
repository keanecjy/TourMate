//
//  TripsViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 17/3/22.
//

import Foundation

@MainActor
class TripsViewModel: ObservableObject {
    @Published private(set) var trips: [Trip]
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool
    private var tripService: TripService

    init(tripService: TripService = FirebaseTripService()) {
        self.trips = []
        self.isLoading = false
        self.hasError = false
        self.tripService = tripService
    }

    func fetchTripsAndListen() async {
        tripService.tripsEventDelegate = self

        self.isLoading = true
        await tripService.fetchTripsAndListen()
    }

    func detachListener() {
        tripService.tripsEventDelegate = nil

        self.isLoading = false
        tripService.detachListener()
    }
}

// MARK: - TripsDelegate
extension TripsViewModel: TripsEventDelegate {
    func update(trips: [Trip], errorMessage: String) async {
        print("Updating Trips: \(trips)")
        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.trips = trips
        self.isLoading = false
    }

    func update(trip: Trip?, errorMessage: String) async {}

}
