//
//  MockPlanService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation

class MockPlanService: PlanService {

    static let creationDate = Date(timeIntervalSince1970: 1_651_400_000)

    var plans: [Plan] = [
        Plan(id: "0", tripId: "0", name: "Hotel Z",
             startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400)),
             endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_480_400)),
             status: .confirmed,
             creationDate: creationDate,
             modificationDate: creationDate,
             upvotedUserIds: []),
        Plan(id: "1", tripId: "0", name: "Visit Tower Bridge",
             startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400),
                                     timeZone: TimeZone(abbreviation: "PST")!),
             endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_467_600),
                                   timeZone: TimeZone(abbreviation: "PST")!),
             imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
             status: .confirmed, creationDate: creationDate,
             modificationDate: creationDate,
             upvotedUserIds: []),
        Plan(id: "2", tripId: "0", name: "Dinner at Spago",
             startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400),
                                     timeZone: TimeZone(abbreviation: "PST")!),
             endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_461_400),
                                   timeZone: TimeZone(abbreviation: "PST")!),
             status: .confirmed, creationDate: creationDate,
             modificationDate: creationDate,
             upvotedUserIds: []),
        Plan(id: "3", tripId: "1", name: "Travel to Kyoto",
             startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400),
                                     timeZone: TimeZone(abbreviation: "MST")!),
             endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_480_400),
                                   timeZone: TimeZone(abbreviation: "MST")!),
             status: .confirmed, creationDate: creationDate,
             modificationDate: creationDate,
             upvotedUserIds: []),
        Plan(id: "4", tripId: "1", name: "Flight to Japan",
             startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_440_400),
                                     timeZone: TimeZone(abbreviation: "MST")!),
             endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400),
                                   timeZone: TimeZone(abbreviation: "MST")!),
             imageUrl: "https://source.unsplash.com/pT0qBgNa0VU",
             status: .confirmed, creationDate: creationDate,
             modificationDate: creationDate,
             upvotedUserIds: [])
    ]

    func addPlan(plan: Plan) async -> (Bool, String) {
        plans.append(plan)
        return (true, "")
    }

    func deletePlan(plan: Plan) async -> (Bool, String) {
        plans = plans.filter({ $0.id != plan.id })
        return (true, "")
    }

    func updatePlan(plan: Plan) async -> (Bool, String) {
        guard let index = plans.firstIndex(where: { $0.id == plan.id }) else {
            return (false, "Plan with planId: \(plan.id) should exist")
        }

        plans[index] = plan
        return (true, "")
    }

    weak var planEventDelegate: PlanEventDelegate?

    func fetchPlansAndListen(withTripId tripId: String) async {}

    func fetchPlanAndListen(withPlanId planId: String) async {}

    func detachListener() {}

}
