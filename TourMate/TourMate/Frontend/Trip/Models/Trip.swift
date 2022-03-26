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
    var imageUrl: String?
    var attendeesUserIds: [String]
    var invitedUserIds: [String]
    let creationDate: Date
    var modificationDate: Date

    internal init(id: String, name: String,
                  startDateTime: DateTime,
                  endDateTime: DateTime,
                  imageUrl: String?,
                  attendeesUserIds: [String],
                  invitedUserIds: [String],
                  creationDate: Date,
                  modificationDate: Date) {
        self.id = id
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.imageUrl = imageUrl
        self.attendeesUserIds = attendeesUserIds
        self.invitedUserIds = invitedUserIds
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

    // For initialization
    init(id: String, name: String,
         startDateTime: DateTime,
         endDateTime: DateTime,
         imageUrl: String?,
         creatorUserId: String) {
        self.id = id
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.imageUrl = imageUrl
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
