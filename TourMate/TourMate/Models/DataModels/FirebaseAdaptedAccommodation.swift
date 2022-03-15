//
//  FirebaseAdaptedAccommodation.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedAccommodation: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedType.firebaseAdaptedAccommodation

    // Plan Fields
    let id: String
    let tripId: String
    let name: String
    let planType: FirebasePlanType
    let startDate: Date
    let endDate: Date
    let timeZone: TimeZone
    let imageUrl: String?
    let status: String
    let creationDate: Date
    let modificationDate: Date

    // Unique Fields
    let address: String?
    let phone: Int?
    let website: String?
}
