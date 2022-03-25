//
//  EditPlanViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import Foundation
import Combine

class EditPlanViewModel<T: Plan>: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    @Published var plan: T
    @Published var isPlanDurationValid = true
    @Published var canEditPlan = true

    var trip: Trip
    let planController: PlanController

    private var cancellableSet: Set<AnyCancellable> = []

    init(plan: T, trip: Trip, planController: PlanController = FirebasePlanController()) {
        self.plan = plan
        self.trip = trip
        self.planController = planController

        $plan
            .map({ $0.startDateTime.date <= $0.endDateTime.date })
            .assign(to: \.isPlanDurationValid, on: self)
            .store(in: &cancellableSet)

        $isPlanDurationValid
            .assign(to: \.canEditPlan, on: self)
            .store(in: &cancellableSet)
    }

    private func modifyPlan(plan: T, function: (Plan) async -> (Bool, String)) async {
        self.isLoading = true

        let (hasUpdatedPlan, errorMessage) = await function(plan)

        guard hasUpdatedPlan, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

    func updatePlan() async {
        await modifyPlan(plan: plan) { plan in
            await planController.updatePlan(plan: plan)
        }
    }

    func deletePlan() async {
        await modifyPlan(plan: plan) { plan in
            await planController.deletePlan(plan: plan)
        }
    }
}
