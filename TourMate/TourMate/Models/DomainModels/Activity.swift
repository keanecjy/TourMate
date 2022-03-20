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
    var startDate: Date
    var endDate: Date
    var startTimeZone: TimeZone
    var endTimeZone: TimeZone?
    var imageUrl: String
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var venue: String?
    var address: String?
    var phone: String?
    var website: String?
}
