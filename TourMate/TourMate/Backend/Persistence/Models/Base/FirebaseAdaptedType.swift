//
//  FirebaseAdaptedType.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

enum FirebaseAdaptedType: String, Codable {
    case firebaseAdaptedUser
    case firebaseAdaptedTrip
    case firebaseAdaptedComment
    case firebaseAdaptedPlan

    var metatype: FirebaseAdaptedData.Type {
        switch self {
        case .firebaseAdaptedUser:
            return FirebaseAdaptedUser.self
        case .firebaseAdaptedTrip:
            return FirebaseAdaptedTrip.self
        case .firebaseAdaptedComment:
            return FirebaseAdaptedComment.self
        case .firebaseAdaptedPlan:
            return FirebaseAdaptedPlan.self
        }
    }
}
