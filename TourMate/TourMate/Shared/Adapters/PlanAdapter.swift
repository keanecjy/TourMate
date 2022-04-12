//
//  PlanAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 19/3/22.
//

import SwiftUI

class PlanAdapter {
    init() {}

    func toAdaptedPlan(plan: Plan) -> FirebaseAdaptedPlan {
        switch plan {
        case let plan as Activity:
            return plan.toData()
        case let plan as Accommodation:
            return plan.toData()
        case let plan as Transport:
            return plan.toData()
        default:
            preconditionFailure("Failed to convert domain plan to data plan")
        }
    }

    func toPlan(adaptedPlan: FirebaseAdaptedPlan) -> Plan {
        switch adaptedPlan {
        case let adaptedPlan as FirebaseAdaptedActivity:
            return adaptedPlan.toItem()
        case let adaptedPlan as FirebaseAdaptedAccommodation:
            return adaptedPlan.toItem()
        case let adaptedPlan as FirebaseAdaptedTransport:
            return adaptedPlan.toItem()
        default:
            preconditionFailure("Failed to convert data plan to domain plan")
        }
    }
}

extension Activity {
    fileprivate func toData() -> FirebaseAdaptedActivity {
        FirebaseAdaptedActivity(id: id, tripId: tripId, name: name,
                                startDateTime: startDateTime.toData(),
                                endDateTime: endDateTime.toData(),
                                imageUrl: imageUrl, status: status.rawValue,
                                creationDate: creationDate,
                                modificationDate: modificationDate,
                                additionalInfo: additionalInfo,
                                ownerUserId: ownerUserId,
                                modifierUserId: modifierUserId,
                                versionNumber: versionNumber,
                                location: location.toData())
    }
}

extension FirebaseAdaptedActivity {
    fileprivate func toItem() -> Activity {
        Activity(id: id, tripId: tripId, name: name,
                 startDateTime: startDateTime.toItem(),
                 endDateTime: endDateTime.toItem(),
                 imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                 creationDate: creationDate, modificationDate: modificationDate,
                 additionalInfo: additionalInfo, ownerUserId: ownerUserId,
                 modifierUserId: modifierUserId, versionNumber: versionNumber,
                 location: location.toItem())
    }
}

extension Accommodation {
    fileprivate func toData() -> FirebaseAdaptedAccommodation {
        FirebaseAdaptedAccommodation(
            id: id, tripId: tripId, name: name,
            startDateTime: startDateTime.toData(),
            endDateTime: endDateTime.toData(),
            imageUrl: imageUrl, status: status.rawValue,
            creationDate: creationDate,
            modificationDate: modificationDate,
            additionalInfo: additionalInfo,
            ownerUserId: ownerUserId,
            modifierUserId: modifierUserId,
            versionNumber: versionNumber,
            location: location.toData())
    }
}

extension FirebaseAdaptedAccommodation {
    fileprivate func toItem() -> Accommodation {
        Accommodation(id: id, tripId: tripId, name: name,
                      startDateTime: startDateTime.toItem(),
                      endDateTime: endDateTime.toItem(),
                      imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                      creationDate: creationDate,
                      modificationDate: modificationDate,
                      additionalInfo: additionalInfo,
                      ownerUserId: ownerUserId,
                      modifierUserId: modifierUserId,
                      versionNumber: versionNumber,
                      location: location.toItem())
    }
}

extension Transport {
    fileprivate func toData() -> FirebaseAdaptedTransport {
        FirebaseAdaptedTransport(
            id: id, tripId: tripId, name: name,
            startDateTime: startDateTime.toData(),
            endDateTime: endDateTime.toData(),
            imageUrl: imageUrl, status: status.rawValue,
            creationDate: creationDate,
            modificationDate: modificationDate,
            additionalInfo: additionalInfo,
            ownerUserId: ownerUserId,
            modifierUserId: modifierUserId,
            versionNumber: versionNumber,
            startLocation: startLocation.toData(),
            endLocation: endLocation.toData())
    }
}

extension FirebaseAdaptedTransport {
    fileprivate func toItem() -> Transport {
        Transport(id: id, tripId: tripId, name: name,
                  startDateTime: startDateTime.toItem(),
                  endDateTime: endDateTime.toItem(),
                  imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                  creationDate: creationDate,
                  modificationDate: modificationDate,
                  additionalInfo: additionalInfo,
                  ownerUserId: ownerUserId,
                  modifierUserId: modifierUserId,
                  versionNumber: versionNumber,
                  startLocation: startLocation.toItem(),
                  endLocation: endLocation.toItem())
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
        JsonAdaptedLocation(country: country,
                            city: city,
                            address_line1: addressLineOne,
                            address_line2: addressLineTwo,
                            formatted: addressFull,
                            lon: longitude, lat: latitude)
    }
}

extension JsonAdaptedLocation {
    fileprivate func toItem() -> Location {
        Location(country: country,
                 city: city,
                 addressLineOne: address_line1,
                 addressLineTwo: address_line2,
                 addressFull: formatted,
                 longitude: lon, latitude: lat)
    }
}
