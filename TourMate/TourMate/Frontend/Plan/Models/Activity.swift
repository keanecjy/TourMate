//
//  Activity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

class Activity: Plan {
    var location: Location?

    // Activity creation
    init(tripId: String
         name: String,
         startDateTime: DateTime,
         endDateTime: DateTime,
         imageUrl: String,
         status: PlanStatus,
         additionalInfo: String,
         ownerUserId: String,
         location: Location?) {
        self.location = location
        super.init(tripId: tripId,
                   name: name,
                   startDateTime: startDateTime,
                   endDateTime: endDateTime,
                   imageUrl: imageUrl,
                   status: status,
                   additionalInfo: additionalInfo,
                   ownerUserId: ownerUserId)
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
         location: Location?) {
        self.location = location

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

    required init() {
        self.location = nil
        super.init()
    }

    override func equals<T>(other: T) -> Bool where T: Plan {
        guard super.equals(other: other),
              let otherActivity = other as? Activity
        else {
            return false
        }

        return location == otherActivity.location
    }
}
