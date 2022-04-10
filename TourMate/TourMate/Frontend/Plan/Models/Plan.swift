//
//  Plan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Plan: CustomStringConvertible, Equatable {
    let id: String
    let tripId: String
    var name: String
    var startDateTime: DateTime
    var endDateTime: DateTime
    var startLocation: Location?
    var endLocation: Location?
    var imageUrl: String
    var status: PlanStatus
    let creationDate: Date
    var modificationDate: Date
    var additionalInfo: String
    var ownerUserId: String
    var modifierUserId: String
    var versionNumber: Int

    var versionedId: String {
        id + " / " + + String(versionNumber)
    }

    // Plan creation
    init(id: String, tripId: String, name: String,
         startDateTime: DateTime, endDateTime: DateTime,
         startLocation: Location? = nil, endLocation: Location? = nil,
         imageUrl: String = "", status: PlanStatus, additionalInfo: String = "",
         ownerUserId: String) {
        self.id = id
        self.tripId = tripId
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.startLocation = startLocation
        self.endLocation = endLocation
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
         startLocation: Location? = nil, endLocation: Location? = nil,
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
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.imageUrl = imageUrl
        self.status = status
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.additionalInfo = additionalInfo
        self.ownerUserId = ownerUserId
        self.modifierUserId = modifierUserId
        self.versionNumber = versionNumber
    }

}

// MARK: - CustomStringConvertible
extension Plan {
    public var description: String {
        "(id: \(id), name: \(name), version: \(versionNumber))"
    }
}
