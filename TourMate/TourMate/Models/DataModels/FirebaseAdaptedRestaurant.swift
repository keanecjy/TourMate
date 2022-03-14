//
//  FirebaseAdaptedRestaurant.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedRestaurant: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedType.firebaseAdaptedRestaurant

    let id: String
    let name: String
    let planType: FirebasePlanType
    let startDate: Date
    let endDate: Date?
    let timeZone: TimeZone
    let imageUrl: String
    let address: String?
    let phone: Int?
    let website: String?
}
