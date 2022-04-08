//
//  MockPlanUpvoteService.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

class MockPlanUpvoteService: PlanUpvoteService {
    required init() {

    }
    
    // From MockPlan and MockUsers
    var planUpvotes = [
        PlanUpvote(planId: "0", userId: "0"),
        PlanUpvote(planId: "0", userId: "1"),
        PlanUpvote(planId: "0", userId: "2")
    ]
    func fetchPlanUpvotesAndListen(withPlanId planId: String) async {
    }

    func addPlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        planUpvotes.append(planUpvote)
        return (true, "")
    }

    func deletePlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        planUpvotes = planUpvotes.filter({ $0.id == planUpvote.id })
        return (true, "")
    }

    func updatePlanUpvote(planUpvote: PlanUpvote) async -> (Bool, String) {
        guard let index = planUpvotes.firstIndex(where: { $0.id == planUpvote.id }) else {
            return (false, "PlanUpvote with ID: \(planUpvote.id) should exist")
        }

        planUpvotes[index] = planUpvote
        return (true, "")
    }

    weak var planUpvoteEventDelegate: PlanUpvoteEventDelegate?

    func detachListener() {
    }

}
