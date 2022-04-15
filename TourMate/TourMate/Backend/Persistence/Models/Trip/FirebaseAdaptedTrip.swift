//
//  FirebaseAdaptedTrip.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedTrip: FirebaseAdaptedData {
    let id: String
    let name: String
    let startDateTime: FirebaseAdaptedDateTime
    let endDateTime: FirebaseAdaptedDateTime
    let location: JsonAdaptedLocation
    let imageUrl: String
    let creatorUserId: String
    let attendeesUserIds: [String]
    let invitedUserIds: [String]
    let creationDate: Date
    let modificationDate: Date

    func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.firebaseAdaptedTrip
    }
}
