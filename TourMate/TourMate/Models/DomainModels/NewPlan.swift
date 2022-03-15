//
//  NewPlan.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import Foundation

struct NewPlan {
    let id: String
    let tripId: String
    var planType: PlanType
    var name: String
    var startDate: Date
    var endDate: Date
    var timeZone: TimeZone
    var imageUrl: String?
    var status: PlanStatus
    let creationDate: Date
    var modificationDate: Date

    // Currently unused
    // let upVote: Int
    // let downVote: Int
    // let comments: [Comments]
}
