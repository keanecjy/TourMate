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
        await modifyTrip { trip in
            await tripController.updateTrip(trip: trip)
        }
    }

    func deleteTrip() async {
        await modifyTrip { trip in
            let (hasDeleted, errorMessage) = await tripController.deleteTrip(trip: trip)
            self.isDeleted = hasDeleted
            return (hasDeleted, errorMessage)
        }
    }

    private func modifyTrip(modifyFunction: (Trip) async -> (Bool, String)) async {
        self.isLoading = true
        let (hasModifiedTrip, tripErrorMessage) = await modifyFunction(trip)
        guard hasModifiedTrip, tripErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }
}
