//
//  FirebaseAdaptedPlan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedPlan: FirebaseAdaptedData {
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

    init(id: String, tripId: String, planType: FirebasePlanType, name: String,
         startDate: Date, endDate: Date, timeZone: TimeZone, imageUrl: String,
         status: String, creationDate: Date, modificationDate: Date) {
        self.id = id
        self.tripId = tripId
        self.planType = planType
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.timeZone = timeZone
        self.imageUrl = imageUrl
        self.status = status
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }

    func getType() -> FirebaseAdaptedType {
        fatalError("Not called")
    }
}
