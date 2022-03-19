//
//  FirebaseAdaptedAccommodation.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedAccommodation: FirebaseAdaptedPlan {
    // Unique Fields
    let address: String?
    let phone: Int?
    let website: String?

    init(id: String, tripId: String, planType: FirebasePlanType, name: String,
         startDate: Date, endDate: Date, timeZone: TimeZone, imageUrl: String,
         status: String, creationDate: Date, modificationDate: Date,
         address: String?, phone: Int?, website: String?) {
        self.address = address
        self.phone = phone
        self.website = website
        super.init(id: id, tripId: tripId, planType: planType,
                   name: name, startDate: startDate, endDate: endDate,
                   timeZone: timeZone, imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.firebaseAdaptedAccommodation
    }
}
