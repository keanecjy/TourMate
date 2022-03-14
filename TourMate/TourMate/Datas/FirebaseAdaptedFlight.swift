//
//  FirebaseAdaptedFlight.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedFlight: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedType.firebaseAdaptedFlight

    var id: String
    let planType: FirebasePlanType
    var name: String
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String
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
