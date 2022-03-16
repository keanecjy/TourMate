//
//  FirebaseAdaptedFlight.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedFlight: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedType.firebaseAdaptedFlight

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
