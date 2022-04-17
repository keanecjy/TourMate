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
        guard !plans.isEmpty else {
            return []
        }

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

    func suggestNewTiming(plans: [Plan], forDate date: Date) -> [Plan] {
        guard !plans.isEmpty else {
            return []
        }

        let filteredPlans = plans.filter { plan in

            // ignore suggestion for all day plans
            let dayStartDate = date
            let dayEndDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!

            if plan.startDateTime.date < dayStartDate && plan.endDateTime.date >= dayEndDate {
                return false
            }

            return !(plan is Accommodation)
        }
        .map { plan in
            plan.copy()
        }

        let suggestedTimings = dateTimeSmartEngine.suggestNewTimings(dateTimeRangeOwners: filteredPlans)
        return suggestedTimings.map { plan in
            plan as! Plan
        }
    }
}
