//
//  Flight.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Flight: Plan {
    var id: Int
    var name: String = "Flight"
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String
    var airline: String
    var flightNumber: Int
    var seats: String?
    var departingLocation: String?
    var departingTerminal: String?
    var departingGate: String?
    var arrivalLocation: String?
    var arrivalTerminal: String?
    var arrivalGate: String?
}
