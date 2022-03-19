//
//  FirebaseAdaptedTransport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedTransport: FirebaseAdaptedPlan {
    var departureLocation: String?
    var departureAddress: String?
    var arrivalLocation: String?
    var arrivalAddress: String?
    var vehicleDescription: String?
    var numberOfPassengers: Int?
    
    private enum CodingKeys: String, CodingKey {
        case departureLocation
        case departureAddress
        case arrivalLocation
        case arrivalAddress
        case vehicleDescription
        case numberOfPassengers
    }
    
    init(id: String, tripId: String, name: String,
         startDate: Date, endDate: Date, timeZone: TimeZone, imageUrl: String,
         status: String, creationDate: Date, modificationDate: Date,
         departureLocation: String?, departureAddress: String?,
         arrivalLocation: String?, arrivalAddress: String?,
         vehicleDescription: String?, numberOfPassengers: Int?) {
        
        self.departureLocation = departureLocation
        self.departureAddress = departureAddress
        self.arrivalLocation = arrivalLocation
        self.arrivalAddress = arrivalAddress
        self.vehicleDescription = vehicleDescription
        self.numberOfPassengers = numberOfPassengers
        
        super.init(id: id, tripId: tripId, name: name, startDate: startDate,
                   endDate: endDate, timeZone: timeZone, imageUrl: imageUrl, status: status,
                   creationDate: creationDate, modificationDate: modificationDate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
        
        
        departureLocation = try container.decode(String.self, forKey: .departureLocation)
        departureAddress = try container.decode(String.self, forKey: .departureAddress)
        arrivalLocation = try container.decode(String.self, forKey: .arrivalLocation)
        arrivalAddress = try container.decode(String.self, forKey: .arrivalAddress)
        vehicleDescription = try container.decode(String.self, forKey: .vehicleDescription)
        numberOfPassengers = try container.decode(Int.self, forKey: .numberOfPassengers)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(departureLocation, forKey: .departureLocation)
        try container.encode(departureAddress, forKey: .departureAddress)
        try container.encode(arrivalLocation, forKey: .arrivalLocation)
        try container.encode(arrivalAddress, forKey: .arrivalAddress)
        try container.encode(vehicleDescription, forKey: .vehicleDescription)
        try container.encode(numberOfPassengers, forKey: .numberOfPassengers)
        
        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }
    
    override func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.firebaseAdaptedTransport
    }
}
