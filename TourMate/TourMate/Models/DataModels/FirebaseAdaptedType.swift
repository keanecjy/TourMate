//
//  FirebaseAdaptedType.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

enum FirebaseAdaptedType: String, Codable {
    case firebaseAdaptedUser
    case firebaseAdaptedTrip
    case firebaseAdaptedAccommodation
    case firebaseAdaptedActivity
    case firebaseAdaptedRestaurant
    case firebaseAdaptedTransport
    case firebaseAdaptedFlight

    var metatype: FirebaseAdaptedData.Type {
        switch self {
        case .firebaseAdaptedUser:
            return FirebaseAdaptedUser.self
        case .firebaseAdaptedTrip:
            return FirebaseAdaptedTrip.self
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
