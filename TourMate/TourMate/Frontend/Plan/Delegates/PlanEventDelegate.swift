//
//  PlanEventDelegate.swift
//  TourMate
//
//  Created by Keane Chan on 26/3/22.
//

protocol PlanEventDelegate: AnyObject {
    func update(plans: [Plan], errorMessage: String) async

    func update(plan: Plan?, errorMessage: String) async
}
