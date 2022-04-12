//
//  FirebaseAdaptedComment.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

struct FirebaseAdaptedComment: FirebaseAdaptedData {
    let planId: String
    let planVersionNumber: Int
    let id: String
    let userId: String
    let message: String
    let creationDate: Date
    var upvotedUserIds: [String]

    func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.firebaseAdaptedComment
    }

}
