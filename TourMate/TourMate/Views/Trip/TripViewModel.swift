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
    @Published private(set) var hasError: Bool
    let tripController: TripController

    init(trip: Trip, tripController: TripController = FirebaseTripController()) {
        self.trip = trip
        self.isLoading = false
        self.hasError = false
        self.tripController = tripController
    }

    func refreshTrip() async {
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

    func deleteTrip(id: String,
                    name: String,
                    startDate: Date,
                    endDate: Date,
                    imageUrl: String? = nil) async {
        await modifyTrip { trip in
            await tripController.deleteTrip(trip: trip)
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
