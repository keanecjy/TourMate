//
//  AddPlanFormViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation
import Combine

@MainActor
class AddPlanFormViewModel<T: Plan>: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    @Published var plan: T
    @Published var isPlanDurationValid = false
    @Published var canAddPlan = false

    var trip: Trip
    let planService: PlanService

    private var cancellableSet: Set<AnyCancellable> = []

    init(plan: T, trip: Trip, planService: PlanService = FirebasePlanService()) {
        self.plan = plan
        self.trip = trip
        self.planService = planService

        $plan
            .map({ $0.startDateTime.date <= $0.endDateTime.date })
            .assign(to: \.isPlanDurationValid, on: self)
            .store(in: &cancellableSet)

        $isPlanDurationValid
            .assign(to: \.canAddPlan, on: self)
            .store(in: &cancellableSet)
    }

    func addPlan() async {
        self.isLoading = true
        if plan.name.isEmpty {
            plan.name = String(describing: T.self)
        }
        let (hasAddedPlan, errorMessage) = await planService.addPlan(plan: plan)
        guard hasAddedPlan, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }
}
