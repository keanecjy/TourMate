//
//  Restaurant.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Restaurant: Plan {
    let planType: PlanType = .restaurant

    var id: String
    var tripId: String
    var name: String = "Restaurant"
    var startDateTime: DateTime
    var endDateTime: DateTime
    var startLocation: Location?
    var endLocation: Location?
    var imageUrl: String?
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date
    var upvotedUserIds: [String]

    var phone: String?
    var website: String?
}
