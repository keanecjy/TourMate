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
    @Published var isShowingTransportationOptionsSheet: Bool

    // Information needed by Plans
    let tripId: String
    let tripStartDateTime: DateTime
    let tripEndDateTime: DateTime

    private var planService: PlanService
    private let viewModelFactory: ViewModelFactory

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

    init(tripId: String,
         tripStartDateTime: DateTime,
         tripEndDateTime: DateTime,
         planService: PlanService) {

        self.plans = []
        self.isLoading = false
        self.hasError = false
        self.isShowingTransportationOptionsSheet = false

        self.tripId = tripId
        self.tripStartDateTime = tripStartDateTime
        self.tripEndDateTime = tripEndDateTime

        self.planService = planService
        self.viewModelFactory = ViewModelFactory()

        self.planEventDelegates = [:]
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
}

// MARK: - View Methods
extension PlansViewModel {
    func makeSuggestionsView() -> some View {
        let binding = Binding(
            get: { self.isShowingTransportationOptionsSheet },
            set: { self.isShowingTransportationOptionsSheet = $0 })

        return VStack(alignment: .leading) {
            Text("TOURMATE ASSISTANT").font(.subheadline)
            ScrollView([.horizontal]) {
                HStack {
                    SuggestionButton(
                        title: "Navigator",
                        subtitle: "Search for transportation options",
                        iconName: "car.fill") {
                        self.isShowingTransportationOptionsSheet.toggle()
                    }
                        .sheet(isPresented: binding) {
                            let viewModel = self.viewModelFactory.getTransportationOptionsViewModel(plans: self.plans)
                            TransportationOptionsView(viewModel: viewModel)
                        }

                    SuggestionButton(title: "Conflict", subtitle: "There are clashing confirmed plans") {
                        print("Implement conflict page")
                    }
                }
            }
        }
        .padding()
    }
}
