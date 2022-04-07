//
//  PlanUpvoteAdapter.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

class PlanUpvoteAdapter {
    init() {}

    func toAdaptedPlanUpvote(planUpvote: PlanUpvote) -> FirebaseAdaptedPlanUpvote {
        planUpvote.toData()
    }

    func toPlanUpvote(adaptedPlanUpvote: FirebaseAdaptedPlanUpvote) -> PlanUpvote {
        adaptedPlanUpvote.toItem()
    }
}

extension PlanUpvote {
    fileprivate func toData() -> FirebaseAdaptedPlanUpvote {
        FirebaseAdaptedPlanUpvote(planId: planId, userId: userId)
    }
}

extension FirebaseAdaptedPlanUpvote {
    fileprivate func toItem() -> PlanUpvote {
        PlanUpvote(planId: planId, userId: userId)
    }
}
