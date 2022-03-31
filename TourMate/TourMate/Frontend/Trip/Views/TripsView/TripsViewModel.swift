//
//  TripsViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 17/3/22.
//

import Foundation
import SwiftUI

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
        tripService.tripEventDelegate = self

        self.isLoading = true
        await tripService.fetchTripsAndListen()
    }

    func detachListener() {
        tripService.tripEventDelegate = nil

        self.isLoading = false
        tripService.detachListener()
    }
}

// MARK: - TripEventDelegate
extension TripsViewModel: TripEventDelegate {
    func update(trips: [Trip], errorMessage: String) async {
        print("[TripsViewModel] Updating Trips: \(trips)")

        guard errorMessage.isEmpty else {
            print("[TripsViewModel] Error updating Trips: \(errorMessage)")
            self.isLoading = false
            self.hasError = true
            return
        }
        self.trips = trips
        self.isLoading = false
    }

    func update(trip: Trip?, errorMessage: String) async {}

}

// MARK: Proposed VM -> View logic
extension TripsViewModel {

    @ViewBuilder
    func buildTripsListView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(trips, id: \.id) { trip in
                    NavigationLink {
                        TripView(trip: trip)
                    } label: {
                        TripCard(title: trip.name,
                                 subtitle: trip.durationDescription,
                                 imageUrl: trip.imageUrl ?? "")
                    }
                }
            }
        }
    }

}
