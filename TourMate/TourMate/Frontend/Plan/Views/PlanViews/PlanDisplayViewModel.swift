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

    var allVersionedPlansSortedDesc: [T]
    @Published var planModifierMap: [Int: User] // version to user map

    let defaultVersionNumberChoice = 0

    var versionNumberChoices: [Int] {
        var choices = [0]
        choices.append(contentsOf: allVersionNumbersSortedDesc)
        return choices
    }

    var versionLabels: [Int: String] {
        var labels: [Int: String] = [:]
        for choice in versionNumberChoices {
            if choice == 0 {
                labels[choice] = "all"
            } else {
                labels[choice] = String(choice)
            }
        }
        return labels
    }

    init(plan: T) {
        self.plan = plan
        self.allVersionedPlansSortedDesc = [plan]
        self.planOwner = User.defaultUser()
        self.planLastModifier = User.defaultUser()
        self.planModifierMap = [:]
    }

    init(plan: T, allVersionedPlans: [T],
         planOwner: User, planLastModifier: User) {
        self.plan = plan
        self.allVersionedPlansSortedDesc = allVersionedPlans
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

    var allVersionNumbersSortedDesc: [Int] {
        allVersionedPlansSortedDesc.map({ $0.versionNumber })
    }

    var latestVersionNumber: Int {
        allVersionNumbersSortedDesc.first ?? versionNumber // Assume current version is latest
    }

    var isLatest: Bool {
        versionNumber == latestVersionNumber
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
