//
//  FirebaseAdaptedTrip.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

struct FirebaseAdaptedTrip: FirebaseAdaptedData {
    static let type = FirebaseAdaptedType.firebaseAdaptedTrip

    let id: String
    let name: String
    let startDate: Date
    let endDate: Date
    let imageUrl: String?
    let userIds: [String]
    let invitedUserIds: [String]
    let creationDate: Date
    let modificationDate: Date
}
