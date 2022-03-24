//
//  Transport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Transport: Plan {
    let planType: PlanType = .transport

    var id: String
    var tripId: String
    var name: String = "Transport"
    var startDateTime: DateTime
    var endDateTime: DateTime
    var startLocation: String
    var endLocation: String?
    var imageUrl: String?
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var vehicleDescription: String?
    var numberOfPassengers: String?
}
