//
//  FirebaseCollectionIds.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Firebase

final class FirebaseConfig {
    static let userCollectionId = "users"
    static let tripCollectionId = "trips"
    static let planCollectionId = "plans"
    static let commentCollectionId = "comments"
    static let upvoteCollectionId = "planUpvotes"

    static func fieldPath(field: String) -> FieldPath {
        FieldPath(["base", field])
    }
}
