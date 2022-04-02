//
//  PlanService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 18/3/22.
//

import Foundation

protocol PlanService {
    func fetchPlansAndListen(withTripId tripId: String) async

    func fetchPlanAndListen(withPlanId planId: String) async

    func addPlan(plan: Plan) async -> (Bool, String)

    func deletePlan(plan: Plan) async -> (Bool, String)

    func updatePlan(plan: Plan) async -> (Bool, String)

    var planEventDelegate: PlanEventDelegate? { get set }

    func detachListener()
}
