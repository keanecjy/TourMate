//
//  NewTrip.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import Foundation

struct NewTrip {
    let id: String
    let userIds: [String]
    let userNames: [String]
    let name: String
    let imageUrl: String
    let creationDate: Date
    let modificationDate: Date

    init(id: String, userIds: [String], userNames: [String], name: String, imageUrl: String,
         creationDate: Date, modificationDate: Date) {
        self.id = id
        self.userIds = userIds
        self.userNames = userNames
        self.name = name
        self.imageUrl = imageUrl
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

    init(userIds: [String], userNames: [String], name: String, imageUrl: String) {
        self.id = UUID().uuidString
        self.userIds = userIds
        self.userNames = userNames
        self.name = name
        self.imageUrl = imageUrl
        self.creationDate = Date.now
        self.modificationDate = Date.now
    }

}
