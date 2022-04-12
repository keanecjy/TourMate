//
//  TripAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 23/3/22.
//

import Foundation
import SwiftUI

class TripAdapter {
    init() {}

    func toAdaptedTrip(trip: Trip) -> FirebaseAdaptedTrip {
        trip.toData()
    }

    func toTrip(adaptedTrip: FirebaseAdaptedTrip) -> Trip {
        adaptedTrip.toItem()
    }
}

extension Trip {
    fileprivate func toData() -> FirebaseAdaptedTrip {
        FirebaseAdaptedTrip(id: id, name: name,
                            startDateTime: startDateTime.toData(),
                            endDateTime: endDateTime.toData(),
                            location: location.toData(),
                            imageUrl: imageUrl,
                            creatorUserId: creatorUserId,
                            attendeesUserIds: attendeesUserIds,
                            invitedUserIds: invitedUserIds,
                            creationDate: creationDate,
                            modificationDate: modificationDate)
    }
}

extension FirebaseAdaptedTrip {
    fileprivate func toItem() -> Trip {
        Trip(id: id, name: name,
             startDateTime: startDateTime.toItem(),
             endDateTime: endDateTime.toItem(),
             location: location.toItem(),
             imageUrl: imageUrl,
             creatorUserId: creatorUserId,
             attendeesUserIds: attendeesUserIds,
             invitedUserIds: invitedUserIds,
             creationDate: creationDate,
             modificationDate: modificationDate)
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
                            lon: longitude,
                            lat: latitude)
    }
}

extension JsonAdaptedLocation {
    fileprivate func toItem() -> Location {
        Location(country: country,
                 city: city,
                 addressLineOne: address_line1,
                 addressLineTwo: address_line2,
                 addressFull: formatted,
                 longitude: lon,
                 latitude: lat)
    }
}
