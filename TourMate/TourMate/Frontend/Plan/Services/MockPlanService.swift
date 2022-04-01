//
//  MockPlanService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation

class MockPlanService: PlanService {

    static let creationDate = Date(timeIntervalSince1970: 1_651_400_000)

    var plans: [Plan] = []

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
