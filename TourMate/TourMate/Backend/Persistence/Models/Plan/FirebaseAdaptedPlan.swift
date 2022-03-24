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
    let startLocation: String
    let endLocation: String?
    let imageUrl: String?
    let status: String
    let creationDate: Date
    let modificationDate: Date

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
    }

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         startLocation: String, endLocation: String?,
         imageUrl: String?, status: String,
         creationDate: Date, modificationDate: Date) {
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
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        tripId = try container.decode(String.self, forKey: .tripId)
        name = try container.decode(String.self, forKey: .name)
        startDateTime = try container.decode(FirebaseAdaptedDateTime.self, forKey: .startDateTime)
        endDateTime = try container.decode(FirebaseAdaptedDateTime.self, forKey: .endDateTime)
        startLocation = try container.decode(String.self, forKey: .startLocation)
        endLocation = try container.decode(String?.self, forKey: .endLocation)
        imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        status = try container.decode(String.self, forKey: .status)
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        modificationDate = try container.decode(Date.self, forKey: .modificationDate)
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
    }

    func getType() -> FirebaseAdaptedType {
        preconditionFailure("This method should not be called")
    }

}
