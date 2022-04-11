//
//  MockPlanService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation

class MockPlanService: PlanService {
    required init() {

    }

    static let creationDate = Date(timeIntervalSince1970: 1_651_400_000)

    var plans: [Plan] = [
        Activity(id: "0", tripId: "0", name: "Run",
                 startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400)),
                 endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_480_400)),
                 imageUrl: "", status: .proposed, creationDate: Date(), modificationDate: Date(),
                 additionalInfo: "", ownerUserId: "0", location: nil),
        Accommodation(id: "1", tripId: "0", name: "Holiday Inn",
                      startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400)),
                      endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_480_400)),
                      imageUrl: "", status: .confirmed, creationDate: Date(), modificationDate: Date(),
                      additionalInfo: "", ownerUserId: "0", location: nil),
        Transport(id: "2", tripId: "0", name: "Travel to Spago",
                  startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400)),
                  endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_461_400)),
                  imageUrl: "", status: .confirmed, creationDate: Date(), modificationDate: Date(),
                  additionalInfo: "", ownerUserId: "0", startLocation: nil, endLocation: nil),
        Transport(id: "3", tripId: "1", name: "Flight to Japan",
                  startDateTime: DateTime(
                    date: Date(timeIntervalSince1970: 1_651_440_400),
                    timeZone: TimeZone(abbreviation: "MST")!),
                  endDateTime: DateTime(
                    date: Date(timeIntervalSince1970: 1_651_460_400),
                    timeZone: TimeZone(abbreviation: "MST")!),
                  imageUrl: "", status: .confirmed, creationDate: Date(), modificationDate: Date(),
                  additionalInfo: "", ownerUserId: "0", startLocation: nil, endLocation: nil),
        Activity(id: "4", tripId: "1", name: "Movie",
                 startDateTime: DateTime(
                    date: Date(timeIntervalSince1970: 1_651_460_400),
                    timeZone: TimeZone(abbreviation: "MST")!),
                 endDateTime: DateTime(
                    date: Date(timeIntervalSince1970: 1_651_480_400),
                    timeZone: TimeZone(abbreviation: "MST")!),
                 imageUrl: "", status: .proposed, creationDate: Date(), modificationDate: Date(),
                 additionalInfo: "", ownerUserId: "0", location: nil)
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
