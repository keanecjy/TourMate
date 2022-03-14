//
//  FirebaseAdaptedActivity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedActivity: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedType.firebaseAdaptedActivity

    let id: String
    let name: String
    let planType: FirebasePlanType
    let startDate: Date
    let endDate: Date?
    let timeZone: TimeZone
    let imageUrl: String
    let venue: String?
    let address: String?
    let phone: Int?
    let website: String?
}
