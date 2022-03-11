//
//  FirebaseAdaptedAccommodation.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedAccommodation: FirebaseAdaptedPlan {
    static var type = FirebaseAdaptedPlanType.firebaseAdaptedAccommodation

    var id: Int
    var name: String
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String
    var address: String?
    var phone: Int?
    var website: String?
}
