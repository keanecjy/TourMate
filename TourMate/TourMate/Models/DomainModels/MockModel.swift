//
//  MockModel.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import Foundation

final class MockModel: ObservableObject {
    @Published var users: [User]
    @Published var trips: [Trip]
    @Published var plans: [Plan]

    func getTrips(forUserId userId: String) -> [Trip] {
        trips.filter({ $0.attendeesUserIds.contains(userId) })
    }

    func getTrip(withTripId tripId: String) -> Trip {
        guard let trip = trips.first(where: { $0.id == tripId }) else {
            preconditionFailure("Trip with tripId: \(tripId) should exist")
        }
        return trip
    }

    func getPlans(forTripId tripId: String) -> [Plan] {
        plans.filter({ $0.tripId == tripId })
    }

    init() {
        let users: [User] = [
            User(id: "0", name: "Abby", email: "abby@gmail.com")
        ]
        self.users = users

        let plans: [Plan] = [
            Activity(id: 0, tripId: "0",
                     name: "Visit Venice Beach",
                     startDate: Date(timeIntervalSince1970: 1_651_442_400),
                     endDate: Date(timeIntervalSince1970: 1_651_453_200),
                     timeZone: TimeZone(abbreviation: "PST")!,
                     imageUrl: "https://source.unsplash.com/qxstzQ__HMk"),
            Restaurant(id: 1, tripId: "0", name: "Dinner at Spago",
                       startDate: Date(timeIntervalSince1970: 1_651_460_400),
                       endDate: Date(timeIntervalSince1970: 1_651_467_600),
                       timeZone: TimeZone(abbreviation: "PST")!,
                       imageUrl: "https://source.unsplash.com/pT0qBgNa0VU"),
            Activity(id: 2, tripId: "1", name: "Visit Grand Canyon",
                     startDate: Date(timeIntervalSince1970: 1_651_475_400),
                     timeZone: TimeZone(abbreviation: "MST")!,
                     imageUrl: "https://source.unsplash.com/pT0qBgNa0VU")
        ]
        self.plans = plans

        self.trips = [
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
    }

}
