//
//  PlanDisplayViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 11/4/22.
//

import Foundation

@MainActor
class PlanDisplayViewModel: ObservableObject {
    @Published var plan: Plan
    @Published var planOwner: User
    @Published var planLastModifier: User

    var allVersionedPlans: [Plan]

    private(set) var displayMode: DisplayMode

    init(plan: Plan) {
        self.plan = plan
        self.allVersionedPlans = [plan]
        self.displayMode = .latestVersion
        self.planOwner = User.defaultUser()
        self.planLastModifier = User.defaultUser()
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
}
