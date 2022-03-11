//
//  FirebaseAdaptedPlan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

protocol FirebaseAdaptedPlan: Codable {
    static var type: FirebaseAdaptedPlanType { get }
    var id: Int { get set }
    var name: String { get set }
    var startDate: Date { get set }
    var endDate: Date? { get set }
    var timeZone: TimeZone { get set }
    var imageUrl: String { get set }
}
