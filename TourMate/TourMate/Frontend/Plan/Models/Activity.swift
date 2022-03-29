//
//  Activity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Activity: Plan {
    let planType: PlanType = .activity

    var id: String
    var tripId: String
    var name: String = "Activity"
    var startDateTime: DateTime
    var endDateTime: DateTime
    var startLocation: String
    var endLocation: String?
    var imageUrl: String?
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date
    var upvotedUserIds: [String]

    var venue: String?
    var phone: String?
    var website: String?
}
