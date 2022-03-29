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
    var planType: PlanType { get }
    var name: String { get set }
    var startDateTime: DateTime { get set }
    var endDateTime: DateTime { get set }
    var startLocation: String { get set }
    var endLocation: String? { get set }
    var imageUrl: String? { get set }
    var status: PlanStatus { get set }
    var creationDate: Date { get }
    var modificationDate: Date { get }
    var upvotedUserIds: [String] { get set }

    // Currently unused
    // var upVote: Int { get set }
    // var downVote: Int { get set }
    // var comments: [Comment] { get set }
}

// MARK: - CustomStringConvertible
extension Plan {
    public var description: String {
        "\(self.planType.rawValue.uppercased()): (id: \(id), name: \(name), planStatus: \(status))"
    }
}
