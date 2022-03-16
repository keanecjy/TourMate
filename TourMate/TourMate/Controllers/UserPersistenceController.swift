//
//  UserPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation
import FirebaseAuth

struct UserPersistenceController {
    let firebasePersistenceManager = FirebasePersistenceManager<FirebaseAdaptedUser>(
        collectionId: FirebaseConfig.userCollectionId)

    func addUser(_ user: User) async -> (Bool, String) {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email,
              email == user.email
        else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        let adaptedUser = user.toData()
        return await firebasePersistenceManager.addItem(id: currentUser.uid, item: adaptedUser)
    }

    func deleteUser() async -> (Bool, String) {
        guard let currentUser = Auth.auth().currentUser else {
            return (false, Constants.messageUserNotLoggedIn)
        }
        return await firebasePersistenceManager.deleteItem(id: currentUser.uid)
    }

    func getUser() async -> (User?, String) {
        guard let currentUser = Auth.auth().currentUser else {
            return (nil, Constants.messageUserNotLoggedIn)
        }
        let (adaptedUser, errorMessage) = await firebasePersistenceManager.fetchItem(id: currentUser.uid)
        return (adaptedUser?.toItem(), errorMessage)
    }

}

extension User {
    fileprivate func toData() -> FirebaseAdaptedUser {
        FirebaseAdaptedUser(id: id, name: name, email: email)
    }
}

extension FirebaseAdaptedUser {
    fileprivate func toItem() -> User {
        User(id: id, name: name, email: email)
    }
}
