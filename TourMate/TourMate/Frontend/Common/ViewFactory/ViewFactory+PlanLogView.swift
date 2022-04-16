//
//  ViewFactory+PlanLogView.swift
//  TourMate
//
//  Created by Terence Ho on 15/4/22.
//

import Foundation
import SwiftUI

// MARK: PlanLogView components
extension ViewFactory {

    func getPlanVersionView<T: Plan>(planDisplayViewModel: PlanDisplayViewModel<T>, plan: T) -> some View {
        let action = plan.versionNumber == 1 ? "created" : "updated"

        let username = planDisplayViewModel.getPlanModifier(version: plan.versionNumber)?.name ?? "someone..."
        let diffMap = getDiffFromPreviousPlan(plans: planDisplayViewModel.allVersionedPlansSortedDesc, plan: plan)

        return PlanLogDisplayHeader(header: "Plan version \(plan.versionNumber) \(action) by \(username)",
                                    planDiffMap: diffMap)
    }

    private func getDiffFromPreviousPlan<T: Plan>(plans: [T], plan: T) -> PlanDiffMap {
        guard let previousPlan = plans.first(where: { $0.versionNumber < plan.versionNumber }) else {
            return [:]
        }

        return previousPlan.diff(other: plan)
    }

    // Will be empty if there are no views to display
    @ViewBuilder
    func getUpvotedUsersView(planUpvoteViewModel: PlanUpvoteViewModel, version: Int) -> some View {
        let upvotedUsers = planUpvoteViewModel.getUpvotedUsersForVersion(version: version)

        if !upvotedUsers.isEmpty {
            let upvotedUsersText = upvotedUsers.map({ $0.name }).joined(separator: ", ")
            let displayText = upvotedUsersText + " liked this version :)"

            PlanLogDisplaySubHeader(subHeader: displayText)
        }
    }
}
