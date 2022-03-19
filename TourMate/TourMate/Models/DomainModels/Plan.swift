//
//  Plan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

protocol Plan {
    var id: String { get }
    var tripId: String { get }
    var planType: PlanType { get }
    var name: String { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }
    var timeZone: TimeZone { get set }
    var imageUrl: String { get set }
    var status: PlanStatus { get set }
    var creationDate: Date { get }
    var modificationDate: Date { get }

    // Currently unused
    // var upVote: Int { get set }
    // var downVote: Int { get set }
    // var comments: [Comment] { get set }
}
