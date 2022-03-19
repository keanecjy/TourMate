//
//  User.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseFirestoreSwift

struct FirebaseAdaptedUser: FirebaseAdaptedData {
    let id: String
    let name: String
    let email: String

    func getType() -> FirebaseAdaptedType {
        FirebaseAdaptedType.firebaseAdaptedUser
    }
}
