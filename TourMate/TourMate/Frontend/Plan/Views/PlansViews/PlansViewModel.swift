//
//  PlansViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/3/22.
//

import SwiftUI

@MainActor
class PlansViewModel: ObservableObject {
    @Published private(set) var plans: [Plan]
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool

    private let planSmartEngine: PlanSmartEngine

    // Information needed by Plans
    let tripId: String
    let tripStartDateTime: DateTime
    let tripEndDateTime: DateTime

    private var planService: PlanService

    private(set) var planEventDelegates: [String: PlanEventDelegate]

    // sort and display Plans by Date
    var days: [Day] {
        let sortedPlans = plans.sorted(by: <)

        let plansByDay: [Date: [Plan]] = sortedPlans.reduce(into: [:]) { acc, cur in
            let components = Calendar
                .current
                .dateComponents(in: cur.startDateTime.timeZone,
                                from: cur.startDateTime.date)
            let startDateComponents = DateComponents(year: components.year,
                                                     month: components.month,
                                                     day: components.day)
            var date = Calendar.current.date(from: startDateComponents)!
            while date <= cur.endDateTime.date {
                let existing = acc[date] ?? []
                acc[date] = existing + [cur]
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            }

        }

        return plansByDay
            .map { (date: $0.key, plans: $0.value) }
            .sorted(by: { $0.date < $1.date })
    }

    var daysWithOverlapSummary: [(Day, String)] {
        var summarisedDays: [(Day, String)] = []

        for day in days {
            let date = day.date
            let plans = day.plans

            let overlappingPlans = planSmartEngine.computeOverlap(plans: plans)
            let overlapSummary = generateOverlapSummary(overlappingPlans: overlappingPlans, forDate: date)

            summarisedDays.append((day, overlapSummary))
        }

        return summarisedDays
    }

    init(tripId: String,
         tripStartDateTime: DateTime,
         tripEndDateTime: DateTime,
         planService: PlanService) {

        self.plans = []
        self.isLoading = false
        self.hasError = false

        self.tripId = tripId
        self.tripStartDateTime = tripStartDateTime
        self.tripEndDateTime = tripEndDateTime

        self.planService = planService

        self.planEventDelegates = [:]
        self.planSmartEngine = PlanSmartEngine()
    }

    func getPlans(for date: Date) -> [Plan] {
        days.first { $0.date == date }?.plans ?? []
    }

    func getInitialDate() -> Date {
        days.first?.date ?? Date()
    }

    func attachDelegate(planId: String, delegate: PlanEventDelegate) {
        planEventDelegates[planId] = delegate
    }

    func detachDelegate(planId: String) {
        planEventDelegates[planId] = nil
    }

    func detachDelegates() {
        planEventDelegates = [:]
    }

    func fetchPlansAndListen() async {
        planService.planEventDelegate = self

        self.isLoading = true
        await planService.fetchPlansAndListen(withTripId: tripId)
    }

    func detachListener() {
        planService.planEventDelegate = nil
        self.isLoading = false

        planService.detachListener()
    }
}

// MARK: - PlanEventDelegate
extension PlansViewModel: PlanEventDelegate {
    func update(plans: [Plan], errorMessage: String) async {
        print("[PlansViewModel] Updating Plans: \(plans)")

        await loadLatestVersionedPlans(plans: plans, errorMessage: errorMessage)
    }

    func update(plan: Plan?, errorMessage: String) async {}
}

// MARK: - Helper Methods
extension PlansViewModel {
    private func loadLatestVersionedPlans(plans: [Plan], errorMessage: String) async {
        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        var latestPlanMap: [String: Plan] = [:]

        for plan in plans {
            // First occurrence of plan
            guard let latestPlan = latestPlanMap[plan.id] else {
                latestPlanMap[plan.id] = plan
                continue
            }

            // Replace with latest plan
            if plan.versionNumber > latestPlan.versionNumber {
                latestPlanMap[plan.id] = plan
            }
        }

        self.plans = Array(latestPlanMap.values)

        for plan in self.plans {
            await planEventDelegates[plan.id]?.update(plan: plan, errorMessage: "")
        }

        self.isLoading = false
    }

    private func generateOverlapSummary(overlappingPlans: [(Plan, Plan)], forDate date: Date) -> String {
        overlappingPlans.map { plan1, plan2 in

            let plan1Duration = DateUtil.shortDurationDesc(from: plan1.startDateTime, to: plan1.endDateTime, on: date)
            let plan2Duration = DateUtil.shortDurationDesc(from: plan2.startDateTime, to: plan2.endDateTime, on: date)

            return "Plan \(plan1.name) (\(plan1Duration)) <-> Plan \(plan2.name) (\(plan2Duration))"
        }
        .joined(separator: "\n")
    }
}
