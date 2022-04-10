//
//  FirebaseAdaptedUpvote.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

struct FirebaseAdaptedPlanUpvote: FirebaseAdaptedData {
    let id: String
    let planId: String
    let userId: String
    let planVersion: Int

    func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.firebaseAdaptedPlanUpvote
    }

}
