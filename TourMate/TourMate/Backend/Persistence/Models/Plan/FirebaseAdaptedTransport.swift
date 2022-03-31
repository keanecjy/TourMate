//
//  FirebaseAdaptedTransport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedTransport: FirebaseAdaptedPlan {
    var vehicleDescription: String?
    var numberOfPassengers: String?

    private enum CodingKeys: String, CodingKey {
        case vehicleDescription
        case numberOfPassengers
    }

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         startLocation: JsonAdaptedLocation?,
         endLocation: JsonAdaptedLocation?,
         imageUrl: String?, status: String,
         creationDate: Date, modificationDate: Date,
         upvotedUserIds: [String],
         vehicleDescription: String?, numberOfPassengers: String?) {

        self.vehicleDescription = vehicleDescription
        self.numberOfPassengers = numberOfPassengers

        super.init(id: id, tripId: tripId, name: name, startDateTime: startDateTime,
                   endDateTime: endDateTime, startLocation: startLocation,
                   endLocation: endLocation, imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate,
                   upvotedUserIds: upvotedUserIds)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        vehicleDescription = try container.decode(String?.self, forKey: .vehicleDescription)
        numberOfPassengers = try container.decode(String?.self, forKey: .numberOfPassengers)

        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(vehicleDescription, forKey: .vehicleDescription)
        try container.encode(numberOfPassengers, forKey: .numberOfPassengers)

        try super.encode(to: encoder)
    }

    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.transport
    }
}
