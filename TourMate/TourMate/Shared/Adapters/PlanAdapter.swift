//
//  PlanAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 19/3/22.
//

class PlanAdapter {
    init() {}

    func toAdaptedPlan(plan: Plan) -> FirebaseAdaptedPlan {
        plan.toData()
    }

    func toPlan(adaptedPlan: FirebaseAdaptedPlan) -> Plan {
        adaptedPlan.toItem()
    }
}

extension Plan {
    fileprivate func toData() -> FirebaseAdaptedPlan {
        FirebaseAdaptedPlan(id: id, tripId: tripId, name: name,
                            startDateTime: startDateTime.toData(),
                            endDateTime: endDateTime.toData(),
                            startLocation: startLocation?.toData(),
                            endLocation: endLocation?.toData(),
                            imageUrl: imageUrl, status: status.rawValue,
                            creationDate: creationDate, modificationDate: modificationDate,
                            additionalInfo: additionalInfo,
                            ownerUserId: ownerUserId, modifierUserId: modifierUserId,
                            versionNumber: versionNumber)
    }
}

extension FirebaseAdaptedPlan {
    fileprivate func toItem() -> Plan {
        Plan(id: id, tripId: tripId, name: name,
             startDateTime: startDateTime.toItem(),
             endDateTime: endDateTime.toItem(),
             startLocation: startLocation?.toItem(),
             endLocation: endLocation?.toItem(),
             imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
             creationDate: creationDate, modificationDate: modificationDate,
             additionalInfo: additionalInfo,
             ownerUserId: ownerUserId, modifierUserId: modifierUserId,
             versionNumber: versionNumber)
    }
}

extension DateTime {
    fileprivate func toData() -> FirebaseAdaptedDateTime {
        FirebaseAdaptedDateTime(date: date, timeZone: timeZone)
    }
}

extension FirebaseAdaptedDateTime {
    fileprivate func toItem() -> DateTime {
        DateTime(date: date, timeZone: timeZone)
    }
}

extension Location {
    fileprivate func toData() -> JsonAdaptedLocation {
        JsonAdaptedLocation(address_line1: addressLineOne,
                            address_line2: addressLineTwo,
                            formatted: addressFull,
                            lon: longitude, lat: latitude)
    }
}

extension JsonAdaptedLocation {
    fileprivate func toItem() -> Location {
        Location(addressLineOne: address_line1,
                 addressLineTwo: address_line2,
                 addressFull: formatted,
                 longitude: lon, latitude: lat)
    }
}
