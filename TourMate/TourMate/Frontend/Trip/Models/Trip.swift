//
//  Trip.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import Foundation

struct Trip: CustomStringConvertible {
    let id: String
    var name: String
    var startDateTime: DateTime
    var endDateTime: DateTime
    var imageUrl: String
    var creatorUserId: String
    var attendeesUserIds: [String]
    var invitedUserIds: [String]
    let creationDate: Date
    var modificationDate: Date

    // START date - END date
    var durationDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full

        dateFormatter.timeZone = startDateTime.timeZone
        let startDateString = dateFormatter.string(from: startDateTime.date)

        dateFormatter.timeZone = endDateTime.timeZone
        let endDateString = dateFormatter.string(from: endDateTime.date)

        return startDateString + " - " + endDateString
    }

    // All fields
    init(id: String, name: String,
         startDateTime: DateTime,
         endDateTime: DateTime,
         imageUrl: String,
         creatorUserId: String,
         attendeesUserIds: [String],
         invitedUserIds: [String],
         creationDate: Date,
         modificationDate: Date) {
        self.id = id
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.imageUrl = imageUrl
        self.creatorUserId = creatorUserId
        self.attendeesUserIds = attendeesUserIds
        self.invitedUserIds = invitedUserIds
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

    // Creation
    init(id: String, name: String,
         startDateTime: DateTime,
         endDateTime: DateTime,
         imageUrl: String,
         creatorUserId: String) {
        self.id = id
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.imageUrl = imageUrl
        self.creatorUserId = creatorUserId
        self.attendeesUserIds = [creatorUserId]
        self.invitedUserIds = []
        self.creationDate = Date.now
        self.modificationDate = Date.now
    }
}

// MARK: - CustomStringConvertible
extension Trip {
    public var description: String {
        "Trip: (id: \(id), name: \(name))"
    }
}
