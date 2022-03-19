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
    var name: String
    var startDate: Date
    var endDate: Date
    var timeZone: TimeZone
    var imageUrl: String
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var address: String?
    var phone: Int?
    var website: String?
}
