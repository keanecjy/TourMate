//
//  FirebaseAdaptedType.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

enum FirebaseAdaptedType: String, Codable {
    case firebaseAdaptedUser
    case firebaseAdaptedTrip
    case accommodation
    case activity
    case restaurant
    case transport
    case flight

    var metatype: FirebaseAdaptedData.Type {
        switch self {
        case .firebaseAdaptedUser:
            return FirebaseAdaptedUser.self
        case .firebaseAdaptedTrip:
            return FirebaseAdaptedTrip.self
        case .accommodation:
            return FirebaseAdaptedAccommodation.self
        case .activity:
            return FirebaseAdaptedActivity.self
        case .restaurant:
            return FirebaseAdaptedRestaurant.self
        case .transport:
            return FirebaseAdaptedTransport.self
        case .flight:
            return FirebaseAdaptedFlight.self
        }
    }
}
