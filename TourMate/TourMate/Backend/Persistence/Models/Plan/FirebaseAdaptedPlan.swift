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
    let startDate: Date
    let endDate: Date
    let timeZone: TimeZone
    let imageUrl: String?
    let status: String
    let creationDate: Date
    let modificationDate: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case tripId
        case name
        case startDate
        case endDate
        case timeZone
        case imageUrl
        case status
        case creationDate
        case modificationDate
    }

    init(id: String, tripId: String, name: String,
         startDate: Date, endDate: Date, timeZone: TimeZone, imageUrl: String?,
         status: String, creationDate: Date, modificationDate: Date) {
        self.id = id
        self.tripId = tripId
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.timeZone = timeZone
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
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        timeZone = try container.decode(TimeZone.self, forKey: .timeZone)
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
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(timeZone, forKey: .timeZone)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(status, forKey: .status)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(modificationDate, forKey: .modificationDate)
    }

    func getType() -> FirebaseAdaptedType {
        preconditionFailure()
    }

}
