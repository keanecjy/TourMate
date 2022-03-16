//
//  MockTripPersistenceController.swift
//  TourMate
//
//  Created by Rayner Lim on 17/3/22.
//

import Foundation

struct MockTripPersistenceController: TripPersistenceControllerProtocol {
    
    var trips: [Trip] = [
        Trip(id: "0", name: "West Coast Summer",
             startDate: Date(timeIntervalSince1970: 1_651_442_400),
             endDate: Date(timeIntervalSince1970: 1_651_480_400),
             imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
             creatorUserId: "0"),
        Trip(id: "1", name: "Winter in Japan",
             startDate: Date(timeIntervalSince1970: 1_651_442_400),
             endDate: Date(timeIntervalSince1970: 1_651_480_400),
             imageUrl: "https://source.unsplash.com/pT0qBgNa0VU",
             creatorUserId: "0")
    ]
    
    func fetchTrips() -> ([Trip], String) {
        return (trips, "")
    }
  
    mutating func addTrip(trip: Trip) -> (Bool, String) {
        trips.append(trip)
        return (true, "")
    }

    mutating func deleteTrip(trip: Trip) -> (Bool, String) {
        trips = trips.filter({ $0.id != trip.id })
        return (true, "")
    }

    mutating func updateTrip(trip: Trip) -> (Bool, String) {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else {
            return(false, "Trip with tripId: \(trip.id) should exist")
        }
        trips[index] = trip
        return (true, "")
    }
}
