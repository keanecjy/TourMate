//
//  PlanUpvote.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

struct PlanUpvote {
    let id: String
    let planId: String
    let userId: String

    init(planId: String, userId: String) {
        self.id = planId + userId
        self.planId = planId
        self.userId = userId
    }
}
