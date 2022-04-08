//
//  PlanFormViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 1/4/22.
//

import Foundation
import Combine

@MainActor
class PlanFormViewModel: ObservableObject {
    let lowerBoundDate: Date
    let upperBoundDate: Date

    @Published var isPlanNameValid: Bool
    @Published var isPlanDurationValid: Bool
    @Published var canSubmitPlan: Bool

    @Published var planStatus: PlanStatus
    @Published var planName: String
    @Published var planStartDate: Date
    @Published var planEndDate: Date
    @Published var planImageUrl: String
    @Published var planAdditionalInfo: String

    @Published var canChangeStatus = true

    private var cancellableSet: Set<AnyCancellable> = []

    // Adding Plan
    init(lowerBoundDate: Date, upperBoundDate: Date) {
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate

        self.isPlanNameValid = false
        self.isPlanDurationValid = true
        self.canSubmitPlan = false

        self.planStatus = .proposed
        self.planName = ""
        self.planStartDate = lowerBoundDate
        self.planEndDate = lowerBoundDate
        self.planImageUrl = ""
        self.planAdditionalInfo = ""

        validate()
    }

    // Editing Plan
    init(lowerBoundDate: Date, upperBoundDate: Date, plan: Plan) {
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate

        self.isPlanNameValid = true
        self.isPlanDurationValid = true
        self.canSubmitPlan = true

        self.planStatus = plan.status
        self.planName = plan.name
        self.planStartDate = plan.startDateTime.date
        self.planEndDate = plan.endDateTime.date
        self.planImageUrl = plan.imageUrl
        self.planAdditionalInfo = plan.additionalInfo

        validate()
    }

    private func validate() {
        // Plan Constraints
        $planName
            .map({ !$0.isEmpty })
            .assign(to: \.isPlanNameValid, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($planStartDate, $planEndDate)
            .map({ max($0, $1) })
            .assign(to: \.planEndDate, on: self)
            .store(in: &cancellableSet)

        // Within date boundaries
        Publishers
            .CombineLatest($planStartDate, $planEndDate)
            .map({ start, end in
                self.lowerBoundDate <= start &&
                start <= end &&
                end <= self.upperBoundDate
            })
            .assign(to: \.isPlanDurationValid, on: self)
            .store(in: &cancellableSet)

        // All validity checks satisfied
        Publishers
            .CombineLatest($isPlanNameValid, $isPlanDurationValid)
            .map({ $0 && $1 })
            .assign(to: \.canSubmitPlan, on: self)
            .store(in: &cancellableSet)

    }
}
