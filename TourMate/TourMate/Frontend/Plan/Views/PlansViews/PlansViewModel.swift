//
//  PlansViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/3/22.
//

import Foundation

@MainActor
class PlansViewModel: ObservableObject {
    @Published private(set) var plans: [Plan]
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool

    // Information needed by Plans
    let tripId: String
    let tripStartDateTime: DateTime
    let tripEndDateTime: DateTime

    private var planService: PlanService

    // sort and display Plans by Date
    typealias Day = (date: Date, plans: [Plan])
    var days: [Day] {
        let sortedPlans = plans.sorted { plan1, plan2 in
            plan1.startDateTime.date < plan2.startDateTime.date
        }

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

        loadLatestVersionedPlans(plans: plans, errorMessage: errorMessage)
    }

    func update(plan: Plan?, errorMessage: String) async {}
}

// MARK: - Helper Methods
extension PlansViewModel {
    private func loadLatestVersionedPlans(plans: [Plan], errorMessage: String) {
        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        var latestPlanMap: [String: Plan] = [:]

        for plan in plans {
            // First occurence of plan
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
        self.isLoading = false
    }
}
