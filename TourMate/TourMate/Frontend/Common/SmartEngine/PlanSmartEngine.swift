//
//  PlanSmartEngine.swift
//  TourMate
//
//  Created by Terence Ho on 17/4/22.
//

import Foundation

struct PlanSmartEngine {
    private let dateTimeSmartEngine = DateTimeSmartEngine()

    func computeOverlap(plans: [Plan]) -> [(Plan, Plan)] {

        let filteredPlans = plans.filter { plan in
            !(plan is Accommodation)
        }

        let overlappingIntervals = dateTimeSmartEngine.computeOverlap(dateTimeRangeOwners: filteredPlans)
        return overlappingIntervals.map { interval in
            let plan1 = interval.0 as! Plan
            let plan2 = interval.1 as! Plan
            return (plan1, plan2)
        }
    }
}
