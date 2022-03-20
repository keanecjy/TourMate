//
//  FirebaseAdaptedActivity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedActivity: FirebaseAdaptedPlan {
    var venue: String?
    var address: String?
    var phone: String?
    var website: String?

    init(id: String, tripId: String, name: String,
         startDate: Date, endDate: Date, timeZone: TimeZone, imageUrl: String?,
         status: String, creationDate: Date, modificationDate: Date, venue: String?,
         address: String?, phone: String?, website: String?) {

        self.venue = venue
        self.address = address
        self.phone = phone
        self.website = website

        super.init(id: id, tripId: tripId, name: name, startDate: startDate,
                   endDate: endDate, timeZone: timeZone, imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate)
    }

    private enum CodingKeys: String, CodingKey {
        case venue
        case address
        case phone
        case website
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)

        venue = try container.decode(String.self, forKey: .venue)
        address = try container.decode(String.self, forKey: .address)
        phone = try container.decode(String.self, forKey: .phone)
        website = try container.decode(String.self, forKey: .website)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(venue, forKey: .venue)
        try container.encode(address, forKey: .address)
        try container.encode(phone, forKey: .phone)
        try container.encode(website, forKey: .website)

        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }

    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.activity
    }
}
