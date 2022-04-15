//
//  PlanDisplayViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 11/4/22.
//

import Foundation

@MainActor
class PlanDisplayViewModel<T: Plan>: ObservableObject {
    @Published var plan: T
    @Published var planOwner: User
    @Published var planLastModifier: User

    var allVersionedPlans: [T]
    @Published var planModifierMap: [Int: User] // version to user map

    var allVersionedPlansSortedDesc: [T] {
        allVersionedPlans.sorted(by: { $0.versionNumber > $1.versionNumber })
    }

    init(plan: T) {
        self.plan = plan
        self.allVersionedPlans = [plan]
        self.planOwner = User.defaultUser()
        self.planLastModifier = User.defaultUser()
        self.planModifierMap = [:]
    }

    init(plan: T, allVersionedPlans: [T],
         planOwner: User, planLastModifier: User) {
        self.plan = plan
        self.allVersionedPlans = allVersionedPlans
        self.planOwner = planOwner
        self.planLastModifier = planLastModifier
        self.planModifierMap = [:]
    }

    var creationDateDisplay: String {
        DateUtil.defaultDateDisplay(date: plan.creationDate, at: plan.startDateTime.timeZone)
    }

    var lastModifiedDateDisplay: String {
        DateUtil.defaultDateDisplay(date: plan.modificationDate, at: plan.startDateTime.timeZone)
    }

    var planId: String {
        plan.id
    }

    var versionNumber: Int {
        plan.versionNumber
    }

    var allVersionNumbers: [Int] {
        allVersionedPlans.map({ $0.versionNumber }).sorted(by: >)
    }

    var prefixedNameDisplay: String {
        ""
    }

    var nameDisplay: String {
        plan.name
    }

    var statusDisplay: PlanStatus {
        plan.status
    }

    var versionNumberDisplay: String {
        String(plan.versionNumber)
    }

    var startDateTimeDisplay: DateTime {
        plan.startDateTime
    }

    var endDateTimeDisplay: DateTime {
        plan.endDateTime
    }

    var additionalInfoDisplay: String {
        plan.additionalInfo
    }

    func getPlanModifier(version: Int) -> User? {
        planModifierMap[version]
    }
}
