//
//  NewTrip.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import Foundation

struct NewTrip {
    let id: String
    var name: String
    var startDate: Date
    var endDate: Date
    var imageUrl: String?
    var userIds: [String]
    var invitedUserIds: [String]
    let creationDate: Date
    var modificationDate: Date

    init(id: String, name: String, startDate: Date, endDate: Date, imageUrl: String?,
         userIds: [String], invitedUserIds: [String],
         creationDate: Date, modificationDate: Date) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.imageUrl = imageUrl
        self.userIds = userIds
        self.invitedUserIds = invitedUserIds
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

    // For initialization
    init(id: String, name: String, startDate: Date, endDate: Date, imageUrl: String?, userId: String) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.imageUrl = imageUrl
        self.userIds = [userId]
        self.invitedUserIds = []
        self.creationDate = Date.now
        self.modificationDate = Date.now
    }

}
