//
//  MockTripController.swift
//  TourMate
//
//  Created by Rayner Lim on 17/3/22.
//

import Foundation

class MockTripController: TripController {
    var trips: [Trip] = [
        Trip(id: "0", name: "West Coast Summer",
             startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_442_400)),
             endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_480_400)),
             imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
             creatorUserId: "0"),
        Trip(id: "1", name: "Winter in Japan",
             startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_442_400)),
             endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_480_400)),
             imageUrl: "https://source.unsplash.com/pT0qBgNa0VU",
             creatorUserId: "0")
    ]

    func fetchTrips() -> ([Trip], String) {
        (trips, "")
    }

    func fetchTrip(withTripId tripId: String) -> (Trip?, String) {
        let trip = trips.first(where: { $0.id == tripId })
        return (trip, "")
    }

    func addTrip(trip: Trip) -> (Bool, String) {
        trips.append(trip)
        return (true, "")
    }

    func deleteTrip(trip: Trip) -> (Bool, String) {
        trips = trips.filter({ $0.id != trip.id })
        return (true, "")
    }

    func updateTrip(trip: Trip) -> (Bool, String) {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else {
            return(false, "Trip with tripId: \(trip.id) should exist")
        }
        trips[index] = trip
        return (true, "")
    }
}
