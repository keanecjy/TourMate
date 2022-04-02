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
    let imageUrl: String?
    let status: String
    let creationDate: Date
    let modificationDate: Date
    let upvotedUserIds: [String]
    var additionalInfo: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case tripId
        case name
        case startDateTime
        case endDateTime
        case startLocation
        case endLocation
        case imageUrl
        case status
        case creationDate
        case modificationDate
        case upvotedUserIds
        case additionalInfo
    }

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         startLocation: JsonAdaptedLocation?, endLocation: JsonAdaptedLocation?,
         imageUrl: String?, status: String,
         creationDate: Date, modificationDate: Date,
         upvotedUserIds: [String],
         additionalInfo: String?) {
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
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        tripId = try container.decode(String.self, forKey: .tripId)
        name = try container.decode(String.self, forKey: .name)
        startDateTime = try container.decode(FirebaseAdaptedDateTime.self, forKey: .startDateTime)
        endDateTime = try container.decode(FirebaseAdaptedDateTime.self, forKey: .endDateTime)
        startLocation = try container.decode(JsonAdaptedLocation?.self, forKey: .startLocation)
        endLocation = try container.decode(JsonAdaptedLocation?.self, forKey: .endLocation)
        imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        status = try container.decode(String.self, forKey: .status)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        modificationDate = try container.decode(Date.self, forKey: .modificationDate)
        upvotedUserIds = try container.decode(Array<String>.self, forKey: .upvotedUserIds)
        additionalInfo = try container.decode(String?.self, forKey: .additionalInfo)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(tripId, forKey: .tripId)
        try container.encode(name, forKey: .name)
        try container.encode(startDateTime, forKey: .startDateTime)
        try container.encode(endDateTime, forKey: .endDateTime)
        try container.encode(startLocation, forKey: .startLocation)
        try container.encode(endLocation, forKey: .endLocation)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(status, forKey: .status)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(modificationDate, forKey: .modificationDate)
        try container.encode(upvotedUserIds, forKey: .upvotedUserIds)
        try container.encode(additionalInfo, forKey: .additionalInfo)
    }

    func getType() -> FirebaseAdaptedType {
        .firebaseAdaptedPlan
    }

}
