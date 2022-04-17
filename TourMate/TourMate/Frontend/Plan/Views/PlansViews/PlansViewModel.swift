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

    private let planSmartEngine: PlanSmartEngine

    // Information needed by Plans
    let tripId: String
    let tripStartDateTime: DateTime
    let tripEndDateTime: DateTime

    private var planService: PlanService
    private(set) var planEventDelegates: [String: PlanEventDelegate]

    var sortedPlans: [Plan] {
        plans.sorted { plan1, plan2 in
            plan1.startDateTime.date < plan2.startDateTime.date
        }
    }

    // sort and display Plans by Date
    typealias Day = (date: Date, plans: [Plan])
    var days: [Day] {
        let sortedPlans = plans.sorted { plan1, plan2 in
            if plan1.startDateTime.date == plan2.startDateTime.date {
                return plan1.endDateTime.date < plan2.endDateTime.date
            }
            return plan1.startDateTime.date < plan2.startDateTime.date
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

    var daysWithOverlapSummary: [(Day, String)] {
        var summarisedDays: [(Day, String)] = []

        for day in days {
            let date = day.date
            let plans = day.plans

            let overlappingPlans = planSmartEngine.computeOverlap(plans: plans)

            var summary = ""

            if !overlappingPlans.isEmpty {
                let overlapSummary = generateOverlapSummary(overlappingPlans: overlappingPlans, forDate: date)
                summary += overlapSummary

                var mappedPlans: [Plan] = []
                for (plan1, plan2) in overlappingPlans {
                    if !mappedPlans.contains(where: { $0.equals(other: plan1) }) {
                        mappedPlans.append(plan1)
                    }

                    if !mappedPlans.contains(where: { $0.equals(other: plan2) }) {
                        mappedPlans.append(plan2)
                    }
                }

                let suggestedTimings = planSmartEngine.suggestNewTiming(plans: mappedPlans, forDate: date)
                if !suggestedTimings.isEmpty {
                    var suggestedTimingSummary = "\n\n"
                    suggestedTimingSummary += generateSuggestedTimingSummary(suggestedTimings: suggestedTimings,
                                                                             forDate: date)
                    summary += suggestedTimingSummary
                }
            }

            summarisedDays.append((day, summary))
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

    private func generateSuggestedTimingSummary(suggestedTimings: [Plan], forDate date: Date) -> String {

        var summary = "Here are some suggested changes:\n"

        summary += suggestedTimings.map { plan in
            let duration = DateUtil.shortDurationDesc(from: plan.startDateTime, to: plan.endDateTime, on: date)
            return "Plan \(plan.name) may be shifted to \(duration)"
        }
        .joined(separator: "\n")

        return summary
    }
}
