//
//  Plan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

protocol Plan {
    var id: Int { get set }
    var tripId: String { get set }
    var name: String { get set }
    var startDate: Date { get set }
    var endDate: Date? { get set }
    var timeZone: TimeZone { get set }
    var imageUrl: String { get set }
}
