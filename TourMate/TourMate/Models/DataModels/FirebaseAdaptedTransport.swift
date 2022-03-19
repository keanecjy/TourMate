//
//  FirebaseAdaptedTransport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedTransport: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedType.firebaseAdaptedTransport

    // Plan Fields
    let id: String
    let tripId: String
    let planType: FirebasePlanType
    let name: String
    let startDate: Date
    let endDate: Date
    let timeZone: TimeZone
    let imageUrl: String
    let status: String
    let creationDate: Date
    let modificationDate: Date

    // Unique Fields
    let departureLocation: String?
    let departureAddress: String?
    let arrivalLocation: String?
    let arrivalAddress: String?
    let vehicleDescription: String?
    let numberOfPassengers: Int?
}
