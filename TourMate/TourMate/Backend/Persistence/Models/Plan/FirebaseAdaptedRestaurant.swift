//
//  FirebaseAdaptedRestaurant.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedRestaurant: FirebaseAdaptedPlan {
    var phone: String?
    var website: String?

    private enum CodingKeys: String, CodingKey {
        case phone
        case website
    }

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         startLocation: String, endLocation: String?,
         imageUrl: String?, status: String,
         creationDate: Date, modificationDate: Date,
         phone: String?, website: String?) {

        self.phone = phone
        self.website = website

        super.init(id: id, tripId: tripId, name: name, startDateTime: startDateTime,
                   endDateTime: endDateTime, startLocation: startLocation,
                   endLocation: endLocation, imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate)
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        phone = try container.decode(String?.self, forKey: .phone)
        website = try container.decode(String?.self, forKey: .website)

        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(phone, forKey: .phone)
        try container.encode(website, forKey: .website)

        try super.encode(to: encoder)
    }

    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.restaurant
    }
}
