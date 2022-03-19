//
//  FirebaseAdaptedActivity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedActivity: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedType.firebaseAdaptedActivity

    // Plan Fields
    let id: String
    let tripId: String
    let planType: FirebasePlanType
    let name: String
    let startDate: Date
    let endDate: Date
    let timeZone: TimeZone
    let imageUrl: String
    let status: String
    let creationDate: Date
    let modificationDate: Date

    // Unique Fields
    let venue: String?
    let address: String?
    let phone: Int?
    let website: String?
}
