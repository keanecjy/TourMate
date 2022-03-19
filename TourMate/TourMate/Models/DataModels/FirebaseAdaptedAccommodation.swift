//
//  FirebaseAdaptedAccommodation.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedAccommodation: FirebaseAdaptedPlan {
    var address: String?
    var phone: Int?
    var website: String?

    private enum CodingKeys: String, CodingKey {
        case address
        case phone
        case website
    }

    init(id: String, tripId: String, name: String,
         startDate: Date, endDate: Date, timeZone: TimeZone, imageUrl: String,
         status: String, creationDate: Date, modificationDate: Date,
         address: String?, phone: Int?, website: String?) {

        self.address = address
        self.phone = phone
        self.website = website

        super.init(id: id, tripId: tripId, name: name, startDate: startDate,
                   endDate: endDate, timeZone: timeZone, imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)

        address = try container.decode(String.self, forKey: .address)
        phone = try container.decode(Int.self, forKey: .phone)
        website = try container.decode(String.self, forKey: .website)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(phone, forKey: .phone)
        try container.encode(website, forKey: .website)

        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }

    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.firebaseAdaptedAccommodation
    }
}
