//
//  FirebaseAdaptedPlan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

protocol FirebaseAdaptedPlan: FirebaseAdaptedData {
    var name: String { get }
    var planType: FirebasePlanType { get }
    var startDate: Date { get }
    var endDate: Date? { get }
    var timeZone: TimeZone { get }
    var imageUrl: String { get }
}
