//
//  TripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation
import Combine

@MainActor
class TripViewModel: ObservableObject {
    @Published var trip: Trip
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    @Published var isTripNameValid = true
    @Published var fromStartDate = Date()...
    @Published var canUpdateTrip = true

    let tripController: TripController

    private var cancellableSet: Set<AnyCancellable> = []

    init(trip: Trip, tripController: TripController = FirebaseTripController()) {
        self.trip = trip
        self.tripController = tripController

        $trip
            .map({ $0.name })
            .map({ !$0.isEmpty })
            .assign(to: \.isTripNameValid, on: self)
            .store(in: &cancellableSet)

        $trip
            .map({ $0.startDate... })
            .assign(to: \.fromStartDate, on: self)
            .store(in: &cancellableSet)

        $isTripNameValid
            .assign(to: \.canUpdateTrip, on: self)
            .store(in: &cancellableSet)
    }

    func fetchTrip() async {
        self.isLoading = true
        let (trip, errorMessage) = await tripController.fetchTrip(withTripId: trip.id)
        guard let trip = trip else {
            self.isDeleted = true
            self.isLoading = false
            return
        }
        guard errorMessage.isEmpty else {
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
