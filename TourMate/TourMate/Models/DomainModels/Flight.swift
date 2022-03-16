//
//  Flight.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Flight: Plan {
    var id: String
    var tripId: String
    var planType: PlanType
    var name: String = "Flight"
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var airline: String
    var flightNumber: Int
    var seats: String?
    var departureLocation: String?
    var departureTerminal: String?
    var departureGate: String?
    var arrivalLocation: String?
    var arrivalTerminal: String?
    var arrivalGate: String?
}
