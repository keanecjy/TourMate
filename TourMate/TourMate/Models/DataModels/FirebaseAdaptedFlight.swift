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
    var departureLocation: String?
    var departureTerminal: String?
    var departureGate: String?
    var arrivalLocation: String?
    var arrivalTerminal: String?
    var arrivalGate: String?

    private enum CodingKeys: String, CodingKey {
        case airline
        case flightNumber
        case seats
        case departureLocation
        case departureTerminal
        case departureGate
        case arrivalLocation
        case arrivalTerminal
        case arrivalGate
    }

    init(id: String, tripId: String, name: String,
         startDate: Date, endDate: Date, timeZone: TimeZone, imageUrl: String?,
         status: String, creationDate: Date, modificationDate: Date,
         airline: String?, flightNumber: String?, seats: String?,
         departureLocation: String?, departureTerminal: String?,
         departureGate: String?, arrivalLocation: String?,
         arrivalTerminal: String?, arrivalGate: String?) {

        self.airline = airline
        self.flightNumber = flightNumber
        self.seats = seats
        self.departureLocation = departureLocation
        self.departureTerminal = departureTerminal
        self.departureGate = departureGate
        self.arrivalLocation = arrivalLocation
        self.arrivalTerminal = arrivalTerminal
        self.arrivalGate = arrivalGate

        super.init(id: id, tripId: tripId, name: name, startDate: startDate,
                   endDate: endDate, timeZone: timeZone, imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        airline = try container.decode(String?.self, forKey: .airline)
        flightNumber = try container.decode(String?.self, forKey: .flightNumber)
        seats = try container.decode(String?.self, forKey: .seats)
        departureLocation = try container.decode(String?.self, forKey: .departureLocation)
        departureTerminal = try container.decode(String?.self, forKey: .departureTerminal)
        departureGate = try container.decode(String?.self, forKey: .departureGate)
        arrivalLocation = try container.decode(String?.self, forKey: .arrivalLocation)
        arrivalTerminal = try container.decode(String?.self, forKey: .arrivalTerminal)
        arrivalGate = try container.decode(String?.self, forKey: .arrivalGate)

        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(airline, forKey: .airline)
        try container.encode(flightNumber, forKey: .flightNumber)
        try container.encode(seats, forKey: .seats)
        try container.encode(departureLocation, forKey: .departureLocation)
        try container.encode(departureTerminal, forKey: .departureTerminal)
        try container.encode(departureGate, forKey: .departureGate)
        try container.encode(arrivalLocation, forKey: .arrivalLocation)
        try container.encode(arrivalTerminal, forKey: .arrivalTerminal)
        try container.encode(arrivalGate, forKey: .arrivalGate)

        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }

    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.flight
    }
}
