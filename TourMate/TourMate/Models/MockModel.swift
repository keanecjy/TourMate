//
//  MockModel.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import Foundation

final class MockModel: ObservableObject {
    @Published var trips: [Trip]

    init() {
        let plans: [Plan] = [
            Activity(id: 0,
                     name: "Visit Venice Beach",
                     startDate: Date(timeIntervalSince1970: 1_651_442_400),
                     endDate: Date(timeIntervalSince1970: 1_651_453_200),
                     timeZone: TimeZone(abbreviation: "PST")!,
                     imageUrl: "https://source.unsplash.com/qxstzQ__HMk"),
            Restaurant(id: 1, name: "Dinner at Spago",
                       startDate: Date(timeIntervalSince1970: 1_651_460_400),
                       endDate: Date(timeIntervalSince1970: 1_651_467_600),
                       timeZone: TimeZone(abbreviation: "PST")!,
                       imageUrl: "https://source.unsplash.com/pT0qBgNa0VU"),
            Activity(id: 2, name: "Visit Grand Canyon",
                     startDate: Date(timeIntervalSince1970: 1_651_475_400),
                     timeZone: TimeZone(abbreviation: "MST")!,
                     imageUrl: "https://source.unsplash.com/pT0qBgNa0VU")
        ]

        self.trips = [
            Trip(id: 0,
                 name: "West Coast Summer",
                 imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
                 plans: plans),
            Trip(id: 1,
                 name: "Winter in Japan",
                 imageUrl: "https://source.unsplash.com/pT0qBgNa0VU",
                 plans: plans)
        ]
    }

}
