//
//  Restaurant.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Restaurant: Plan {

    var id: String
    var tripId: String
    var planType: PlanType
    var name: String
    var startDate: Date
    var endDate: Date?
    var startTimeZone: TimeZone
    var endTimeZone: TimeZone?
    var imageUrl: String?
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var address: String?
    var phone: String?
    var website: String?
}
