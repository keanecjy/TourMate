//
//  FirebaseAdaptedTransport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedTransport: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedPlanType.firebaseAdaptedTransport

    var id: Int
    var name: String
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String
    var departureLocation: String?
    var departureAddress: String?
    var arrivalLocation: String?
    var arrivalAddress: String?
    var vehicleDescription: String?
    var numberOfPassengers: Int?
}
