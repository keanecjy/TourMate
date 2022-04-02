//
//  Plan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Plan: CustomStringConvertible {
    let id: String
    let tripId: String
    var name: String
    var startDateTime: DateTime
    var endDateTime: DateTime
    var startLocation: Location?
    var endLocation: Location?
    var imageUrl: String?
    var status: PlanStatus
    let creationDate: Date
    let modificationDate: Date
    var upvotedUserIds: [String]
    var additionalInfo: String?
}

// MARK: - CustomStringConvertible
extension Plan {
    public var description: String {
        "(id: \(id), name: \(name), planStatus: \(status))"
    }
}
