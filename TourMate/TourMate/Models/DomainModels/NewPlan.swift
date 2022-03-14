//
//  NewPlan.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import Foundation

struct NewPlan {
    let planId: String
    let tripId: String
    let name: String
    let startDate: Date
    let endDate: Date
    let timeZone: TimeZone
    let imageUrl: String
    let status: PlanStatus
    let creationDate: Date
    let modificationDate: Date

    // Currently unused
    let upVote: Int
    let downVote: Int
    let comments: [Comments]
}
