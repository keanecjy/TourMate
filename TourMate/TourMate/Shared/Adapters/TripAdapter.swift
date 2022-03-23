//
//  TripAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 23/3/22.
//

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
        FirebaseAdaptedTrip(id: id, name: name, startDate: startDate, endDate: endDate, timeZone: timeZone,
                            imageUrl: imageUrl, attendeesUserIds: attendeesUserIds, invitedUserIds: invitedUserIds,
                            creationDate: creationDate, modificationDate: modificationDate)
    }
}

extension FirebaseAdaptedTrip {
    fileprivate func toItem() -> Trip {
        Trip(id: id, name: name, startDate: startDate, endDate: endDate, timeZone: timeZone,
             imageUrl: imageUrl, attendeesUserIds: attendeesUserIds, invitedUserIds: invitedUserIds,
             creationDate: creationDate, modificationDate: modificationDate)
    }
}
