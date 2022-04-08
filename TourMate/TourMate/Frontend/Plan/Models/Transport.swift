//
//  Transport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

struct Transport: Plan {
    var id: String
    var tripId: String
    var name: String
    var startDateTime: DateTime
    var endDateTime: DateTime
    var imageUrl: String
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date
    var additionalInfo: String
    var ownerUserId: String

    var startLocation: Location?
    var endLocation: Location?
}
