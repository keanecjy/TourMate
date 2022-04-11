//
//  Plan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

class Plan: CustomStringConvertible, Equatable {
    static func == <T: Plan>(lhs: Plan, rhs: T) -> Bool {
        lhs.id == rhs.id
        && lhs.tripId == rhs.tripId
        && lhs.name == rhs.name
        && lhs.startDateTime == rhs.startDateTime
        && lhs.endDateTime == rhs.endDateTime
        && lhs.creationDate == rhs.creationDate
        && lhs.additionalInfo == rhs.additionalInfo
        && lhs.ownerUserId == rhs.ownerUserId

    }

    var id: String
    var tripId: String
    var name: String
    var startDateTime: DateTime
    var endDateTime: DateTime
    var imageUrl: String
    var status: PlanStatus
    let creationDate: Date
    var modificationDate: Date
    var additionalInfo: String
    var ownerUserId: String
    var modifierUserId: String
    var versionNumber: Int

    var versionedId: String {
        id + "-" + String(versionNumber)
    }

    // Plan creation
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
        self.creationDate = Date()
        self.modificationDate = Date()
        self.additionalInfo = additionalInfo
        self.ownerUserId = ownerUserId
        self.modifierUserId = ownerUserId
        self.versionNumber = 1
    }

    // All fields
    init(id: String, tripId: String, name: String,
         startDateTime: DateTime, endDateTime: DateTime,
         imageUrl: String = "", status: PlanStatus,
         creationDate: Date, modificationDate: Date,
         additionalInfo: String = "",
         ownerUserId: String, modifierUserId: String,
         versionNumber: Int) {
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
        self.modifierUserId = modifierUserId
        self.versionNumber = versionNumber
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
        self.modifierUserId = ""
        self.versionNumber = 0
    }
}

// MARK: - CustomStringConvertible
extension Plan {
    public var description: String {
        "(id: \(id), name: \(name), version: \(versionNumber))"
    }
}
