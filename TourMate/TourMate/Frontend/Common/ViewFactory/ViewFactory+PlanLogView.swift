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
        let diff = getDiffFromPreviousPlan(plans: planDisplayViewModel.allVersionedPlansSortedDesc, plan: plan)

        return PlanLogDisplayHeader(header: "Plan version \(plan.versionNumber) \(action) by \(username)",
                                    subheader: diff)
    }

    private func getDiffFromPreviousPlan<T: Plan>(plans: [T], plan: T) -> String {
        guard let previousPlan = plans.first(where: { $0.versionNumber < plan.versionNumber }) else {
            return ""
        }

        let differenceMap = plan.diff(other: previousPlan)

        return differenceMap.map({ "\($0) changed from \($1.0) to \($1.1)" }).joined(separator: "\n")
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
