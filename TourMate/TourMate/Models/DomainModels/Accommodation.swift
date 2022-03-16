//
//  Accommodation.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Accommodation: Plan {
    var id: Int
    var tripId: String
    var name: String = "Accommodation"
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String
    var address: String?
    var phone: Int?
    var website: String?
}
