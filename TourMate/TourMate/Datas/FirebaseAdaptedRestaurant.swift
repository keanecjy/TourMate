//
//  FirebaseAdaptedRestaurant.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedRestaurant: FirebaseAdaptedPlan {
    static var type = FirebaseAdaptedPlanType.firebaseAdaptedRestaurant

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

