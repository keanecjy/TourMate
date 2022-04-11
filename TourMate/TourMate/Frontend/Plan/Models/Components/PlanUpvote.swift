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
    let planVersion: Int

    init(planId: String, userId: String, planVersion: Int) {
        let id = planId + "-" + String(planVersion) + "-" + userId
        self.init(id: id, planId: planId, userId: userId, planVersion: planVersion)
    }

    init(id: String, planId: String, userId: String, planVersion: Int) {
        self.id = id
        self.planId = planId
        self.userId = userId
        self.planVersion = planVersion
    }
}
