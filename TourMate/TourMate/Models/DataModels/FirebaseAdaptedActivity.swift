//
//  FirebaseAdaptedActivity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

class FirebaseAdaptedActivity: FirebaseAdaptedPlan {
    static let type = FirebaseAdaptedType.firebaseAdaptedActivity

    // Unique Fields
    let venue: String?
    let address: String?
    let phone: Int?
    let website: String?
}
