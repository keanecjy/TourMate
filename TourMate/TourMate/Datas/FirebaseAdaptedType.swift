//
//  FirebaseAdaptedType.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

enum FirebaseAdaptedType: String, Codable {
    case firebaseAdaptedUser
    case firebaseAdaptedTrip

    var metatype: FirebaseAdaptedData.Type {
        switch self {
        case .firebaseAdaptedUser:
            return FirebaseAdaptedUser.self
        case .firebaseAdaptedTrip:
            return FirebaseAdaptedTrip.self
        }
    }
}
