//
//  FirebaseAdaptedTrip.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import FirebaseFirestoreSwift

struct FirebaseAdaptedTrip: FirebaseAdaptedData {
    static let type = FirebaseAdaptedType.firebaseAdaptedTrip

    let id: String
    let userIds: [String]
    let userNames: [String]
    let name: String
    let imageUrl: String
    let creationDate: Date
    let modificationDate: Date
}
