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
                            imageUrl: imageUrl,
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
             imageUrl: imageUrl,
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
