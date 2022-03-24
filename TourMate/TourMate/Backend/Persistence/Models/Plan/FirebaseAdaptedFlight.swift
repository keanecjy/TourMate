//
//  FirebaseAdaptedFlight.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedFlight: FirebaseAdaptedPlan {
    var airline: String?
    var flightNumber: String?
    var seats: String?
    var departureTerminal: String?
    var departureGate: String?
    var arrivalTerminal: String?
    var arrivalGate: String?

    private enum CodingKeys: String, CodingKey {
        case airline
        case flightNumber
        case seats
        case departureTerminal
        case departureGate
        case arrivalTerminal
        case arrivalGate
    }

    init(id: String, tripId: String, name: String,
         startDateTime: FirebaseAdaptedDateTime,
         endDateTime: FirebaseAdaptedDateTime,
         startLocation: String, endLocation: String?,
         imageUrl: String?, status: String,
         creationDate: Date, modificationDate: Date,
         airline: String?, flightNumber: String?,
         seats: String?, departureTerminal: String?,
         departureGate: String?, arrivalTerminal: String?,
         arrivalGate: String?) {

        self.airline = airline
        self.flightNumber = flightNumber
        self.seats = seats
        self.departureTerminal = departureTerminal
        self.departureGate = departureGate
        self.arrivalTerminal = arrivalTerminal
        self.arrivalGate = arrivalGate

        super.init(id: id, tripId: tripId, name: name,
                   startDateTime: startDateTime,
                   endDateTime: endDateTime,
                   startLocation: startLocation,
                   endLocation: endLocation,
                   imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        airline = try container.decode(String?.self, forKey: .airline)
        flightNumber = try container.decode(String?.self, forKey: .flightNumber)
        seats = try container.decode(String?.self, forKey: .seats)
        departureTerminal = try container.decode(String?.self, forKey: .departureTerminal)
        departureGate = try container.decode(String?.self, forKey: .departureGate)
        arrivalTerminal = try container.decode(String?.self, forKey: .arrivalTerminal)
        arrivalGate = try container.decode(String?.self, forKey: .arrivalGate)

        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(airline, forKey: .airline)
        try container.encode(flightNumber, forKey: .flightNumber)
        try container.encode(seats, forKey: .seats)
        try container.encode(departureTerminal, forKey: .departureTerminal)
        try container.encode(departureGate, forKey: .departureGate)
        try container.encode(arrivalTerminal, forKey: .arrivalTerminal)
        try container.encode(arrivalGate, forKey: .arrivalGate)

        try super.encode(to: encoder)
    }

    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.flight
    }
}
