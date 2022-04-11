//
//  Plan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

class Plan: CustomStringConvertible {
    var id: String
    var tripId: String
    var name: String
    var startDateTime: DateTime
    var endDateTime: DateTime
    var imageUrl: String
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date
    var additionalInfo: String
    var ownerUserId: String

    init(id: String, tripId: String, name: String,
         startDateTime: DateTime, endDateTime: DateTime,
         imageUrl: String, status: PlanStatus, creationDate: Date,
         modificationDate: Date, additionalInfo: String, ownerUserId: String) {
        self.id = id
        self.tripId = tripId
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.imageUrl = imageUrl
        self.status = status
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.additionalInfo = additionalInfo
        self.ownerUserId = ownerUserId
    }

    init() {
        self.id = ""
        self.tripId = ""
        self.name = ""
        self.startDateTime = DateTime()
        self.endDateTime = DateTime()
        self.imageUrl = ""
        self.status = .proposed
        self.creationDate = Date()
        self.modificationDate = Date()
        self.additionalInfo = ""
        self.ownerUserId = ""
    }
}

// MARK: - CustomStringConvertible
extension Plan {
    public var description: String {
        "(id: \(id), name: \(name), planStatus: \(status))"
    }
}
