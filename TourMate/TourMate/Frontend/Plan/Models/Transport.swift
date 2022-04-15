//
//  Transport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

class Transport: Plan {
    var startLocation: Location
    var endLocation: Location

    override var locations: [Location] {
        return [ startLocation, endLocation ]
    }

    init(plan: Plan, startLocation: Location, endLocation: Location) {
        self.startLocation = startLocation
        self.endLocation = endLocation
        super.init(plan: plan)
    }

    // All fields
    init(id: String, tripId: String, name: String,
         startDateTime: DateTime,
         endDateTime: DateTime,
         imageUrl: String = "",
         status: PlanStatus,
         creationDate: Date,
         modificationDate: Date,
         additionalInfo: String = "",
         ownerUserId: String,
         modifierUserId: String,
         versionNumber: Int,
         startLocation: Location,
         endLocation: Location) {
        self.startLocation = startLocation
        self.endLocation = endLocation

        super.init(id: id, tripId: tripId, name: name,
                   startDateTime: startDateTime,
                   endDateTime: endDateTime,
                   imageUrl: imageUrl,
                   status: status,
                   creationDate: creationDate,
                   modificationDate: modificationDate,
                   additionalInfo: additionalInfo,
                   ownerUserId: ownerUserId,
                   modifierUserId: modifierUserId,
                   versionNumber: versionNumber)
    }

    override func equals<T>(other: T) -> Bool where T: Plan {
        guard super.equals(other: other),
              let otherTransport = other as? Transport
        else {
            return false
        }

        return startLocation == otherTransport.startLocation
        && endLocation == otherTransport.endLocation
    }

    override var description: String {
        "(Transport: \(super.description))"
    }
}
