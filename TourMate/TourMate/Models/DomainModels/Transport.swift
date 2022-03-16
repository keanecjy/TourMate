//
//  Transport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Transport: Plan {
    var id: Int
    var tripId: String
    var name: String = "Transport"
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String
    var departureLocation: String?
    var departureAddress: String?
    var arrivalLocation: String?
    var arrivalAddress: String?
    var vehicleDescription: String?
    var numberOfPassengers: Int?
}
