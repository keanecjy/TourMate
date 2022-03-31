//
//  FirebaseAdaptedActivity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedActivity: FirebaseAdaptedPlan {
    var venue: String?
    var phone: String?
    var website: String?

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         startLocation: JsonAdaptedLocation?,
         endLocation: JsonAdaptedLocation?,
         imageUrl: String?, status: String,
         creationDate: Date, modificationDate: Date,
         upvotedUserIds: [String],
         venue: String?, phone: String?, website: String?) {

        self.venue = venue
        self.phone = phone
        self.website = website

        super.init(id: id, tripId: tripId, name: name,
                   startDateTime: startDateTime,
                   endDateTime: endDateTime,
                   startLocation: startLocation,
                   endLocation: endLocation,
                   imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate,
                   upvotedUserIds: upvotedUserIds)
    }

    private enum CodingKeys: String, CodingKey {
        case venue
        case phone
        case website
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        venue = try container.decode(String?.self, forKey: .venue)
        phone = try container.decode(String?.self, forKey: .phone)
        website = try container.decode(String?.self, forKey: .website)

        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(venue, forKey: .venue)
        try container.encode(phone, forKey: .phone)
        try container.encode(website, forKey: .website)

        try super.encode(to: encoder)
    }

    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.activity
    }
}
