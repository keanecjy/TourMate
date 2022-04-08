//
//  Plan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

protocol Plan: CustomStringConvertible {
    var id: String { get }
    var tripId: String { get }
    var name: String { get set }
    var startDateTime: DateTime { get set }
    var endDateTime: DateTime { get set }
    var imageUrl: String { get set }
    var status: PlanStatus { get set }
    var creationDate: Date { get }
    var modificationDate: Date { get }
    var additionalInfo: String { get set }
    var ownerUserId: String { get set }
}

// MARK: - CustomStringConvertible
extension Plan {
    public var description: String {
        "(id: \(id), name: \(name), planStatus: \(status))"
    }
}
