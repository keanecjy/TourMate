//
//  FirebaseAdaptedTransport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import Foundation

class FirebaseAdaptedTransport: FirebaseAdaptedPlan {
    let startLocation: JsonAdaptedLocation?
    let endLocation: JsonAdaptedLocation?

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         imageUrl: String, status: String,
         creationDate: Date, modificationDate: Date,
         additionalInfo: String, ownerUserId: String,
         startLocation: JsonAdaptedLocation?,
         endLocation: JsonAdaptedLocation) {
        self.startLocation = startLocation
        self.endLocation = endLocation
        super.init(id: id, tripId: tripId, name: name,
                   startDateTime: startDateTime,
                   endDateTime: endDateTime,
                   imageUrl: imageUrl, status: status,
                   creationDate: creationDate,
                   modificationDate: modificationDate,
                   additionalInfo: additionalInfo,
                   ownerUserId: ownerUserId)
    }

    private enum CodingKeys: String, CodingKey {
        case startLocation
        case endLocation
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        startLocation = try container.decode(JsonAdaptedLocation?.self, forKey: .startLocation)
        endLocation = try container.decode(JsonAdaptedLocation?.self, forKey: .endLocation)

        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(startLocation, forKey: .startLocation)
        try container.encode(endLocation, forKey: .endLocation)

        try super.encode(to: encoder)
    }

    override func getType() -> FirebaseAdaptedType {
        .firebaseAdaptedTransport
    }
}
