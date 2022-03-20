//
//  Accommodation.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Accommodation: Plan {
<<<<<<< HEAD
=======
    let planType: PlanType = .accommodation
>>>>>>> main

    var id: String
    var tripId: String
    var name: String = "Accommodation"
    var startDate: Date
<<<<<<< HEAD
    var endDate: Date?
    var startTimeZone: TimeZone
    var endTimeZone: TimeZone?
    var imageUrl: String?
=======
    var endDate: Date
    var timeZone: TimeZone
    var imageUrl: String
>>>>>>> main
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var address: String?
    var phone: String?
    var website: String?
}
