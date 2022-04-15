//
//  FirebaseAdaptedActivity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

class FirebaseAdaptedActivity: FirebaseAdaptedPlan {

    let location: JsonAdaptedLocation

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         imageUrl: String, status: String,
         creationDate: Date, modificationDate: Date,
         additionalInfo: String, ownerUserId: String,
         modifierUserId: String, versionNumber: Int,
         location: JsonAdaptedLocation) {
        self.location = location
        super.init(id: id, tripId: tripId, name: name,
                   startDateTime: startDateTime,
                   endDateTime: endDateTime,
                   imageUrl: imageUrl, status: status,
                   creationDate: creationDate,
                   modificationDate: modificationDate,
                   additionalInfo: additionalInfo,
                   ownerUserId: ownerUserId,
                   modifierUserId: modifierUserId,
                   versionNumber: versionNumber)

    }

    private enum CodingKeys: String, CodingKey {
        case location
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        location = try container.decode(JsonAdaptedLocation.self, forKey: .location)

        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(location, forKey: .location)

        try super.encode(to: encoder)
    }

    override func getType() -> FirebaseAdaptedType {
        .firebaseAdaptedActivity
    }
}
