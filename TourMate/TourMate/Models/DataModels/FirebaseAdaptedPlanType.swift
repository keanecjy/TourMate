//
//  FirebaseAdaptedPlanType.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

enum FirebaseAdaptedPlanType: String, Codable {
    case firebaseAdaptedAccommodation
    case firebaseAdaptedActivity
    case firebaseAdaptedRestaurant
    case firebaseAdaptedTransport
    case firebaseAdaptedFlight

    var metatype: FirebaseAdaptedPlan.Type {
        switch self {
        case .firebaseAdaptedAccommodation:
            return FirebaseAdaptedAccommodation.self
        case .firebaseAdaptedActivity:
            return FirebaseAdaptedActivity.self
        case .firebaseAdaptedRestaurant:
            return FirebaseAdaptedRestaurant.self
        case .firebaseAdaptedTransport:
            return FirebaseAdaptedTransport.self
        case .firebaseAdaptedFlight:
            return FirebaseAdaptedFlight.self
        }
    }
}
