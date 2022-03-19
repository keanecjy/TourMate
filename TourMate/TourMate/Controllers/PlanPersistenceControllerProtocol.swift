//
//  PlanPersistenceControllerProtocol.swift
//  TourMate
//
//  Created by Tan Rui Quan on 18/3/22.
//

import Foundation

protocol PlanPersistenceControllerProtocol {
    func fetchPlans(withTripId tripId: String) async -> ([Plan], String)

    func addPlan(plan: Plan) async -> (Bool, String)

    func deletePlan(plan: Plan) async -> (Bool, String)

    func updatePlan(plan: Plan) async -> (Bool, String)
}
