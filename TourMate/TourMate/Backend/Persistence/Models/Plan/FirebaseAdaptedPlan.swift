//
//  FirebaseAdaptedPlan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedPlan: FirebaseAdaptedData {
    let id: String
    let tripId: String
    let name: String
    let startDateTime: FirebaseAdaptedDateTime
    let endDateTime: FirebaseAdaptedDateTime
    let startLocation: JsonAdaptedLocation?
    let endLocation: JsonAdaptedLocation?
    let imageUrl: String
    let status: String
    let creationDate: Date
    let modificationDate: Date
    let upvotedUserIds: [String]
    var additionalInfo: String
    var ownerUserId: String

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         startLocation: JsonAdaptedLocation?, endLocation: JsonAdaptedLocation?,
         imageUrl: String, status: String,
         creationDate: Date, modificationDate: Date,
         upvotedUserIds: [String],
         additionalInfo: String, ownerUserId: String) {
        self.id = id
        self.tripId = tripId
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.imageUrl = imageUrl
        self.status = status
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.upvotedUserIds = upvotedUserIds
        self.additionalInfo = additionalInfo
        self.ownerUserId = ownerUserId
    }

    func getType() -> FirebaseAdaptedType {
        .firebaseAdaptedPlan
    }

}
