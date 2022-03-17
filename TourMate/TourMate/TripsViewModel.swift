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
    let tripService: TripPersistenceControllerProtocol

    init(tripService: TripPersistenceControllerProtocol = TripPersistenceController()) {
        self.trips = []
        self.isLoading = false
        self.hasError = false
        self.tripService = tripService
    }

    func fetchTrips() async {
        self.isLoading = true
        let (trips, errorMessage) = await tripService.fetchTrips()
        guard errorMessage == "" else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.trips = trips
        self.isLoading = false
    }
}
