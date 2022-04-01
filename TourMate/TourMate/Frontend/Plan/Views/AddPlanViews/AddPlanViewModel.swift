//
//  AddPlanFormViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation
import Combine

@MainActor
class AddPlanViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    @Published var plan: Plan
    @Published var isPlanDurationValid = false
    @Published var canAddPlan = false

    var trip: Trip
    let planService: PlanService

    private var cancellableSet: Set<AnyCancellable> = []

    init(trip: Trip, planService: PlanService = FirebasePlanService()) {
        let tripId = trip.id
        let planId = tripId + UUID().uuidString
        let startDateTime = trip.startDateTime
        let endDateTime = trip.startDateTime

        self.plan = Plan(id: planId, tripId: tripId, name: "",
                         startDateTime: startDateTime, endDateTime: endDateTime,
                         startLocation: "", endLocation: "", imageUrl: "",
                         status: .proposed, creationDate: Date(),
                         modificationDate: Date(), upvotedUserIds: [])

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
            plan.name = String(describing: Plan.self)
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
