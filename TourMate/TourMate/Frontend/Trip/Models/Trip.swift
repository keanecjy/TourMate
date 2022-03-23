//
//  Trip.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import Foundation

struct Trip {
    let id: String
    var name: String
    var startDate: Date
    var endDate: Date
    var timeZone: TimeZone
    var imageUrl: String?
    var attendeesUserIds: [String]
    var invitedUserIds: [String]
    let creationDate: Date
    var modificationDate: Date

    init(id: String, name: String, startDate: Date, endDate: Date, timeZone: TimeZone, imageUrl: String?,
         attendeesUserIds: [String], invitedUserIds: [String],
         creationDate: Date, modificationDate: Date) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.timeZone = timeZone
        self.imageUrl = imageUrl
        self.attendeesUserIds = attendeesUserIds
        self.invitedUserIds = invitedUserIds
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

    // For initialization
    init(id: String, name: String, startDate: Date, endDate: Date, imageUrl: String?, creatorUserId: String) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.timeZone = TimeZone.current
        self.imageUrl = imageUrl
        self.attendeesUserIds = [creatorUserId]
        self.invitedUserIds = []
        self.creationDate = Date.now
        self.modificationDate = Date.now
    }

}
