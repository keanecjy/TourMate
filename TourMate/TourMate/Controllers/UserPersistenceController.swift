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

    func addUser(name: String, email: String, password: String) async -> (Bool, String) {
        let user = User(name: name, email: email, password: password)
        let adaptedUser = user.toData()
        return await firebasePersistenceManager.addItem(item: adaptedUser)
    }

    func deleteUser() async -> (Bool, String) {
        guard let user = Auth.auth().currentUser,
              let email = user.email
        else {
            return (false, "User is not logged in")
        }
        return await firebasePersistenceManager.deleteItem(id: email)
    }

}

extension User {
    fileprivate func toData() -> FirebaseAdaptedUser {
        FirebaseAdaptedUser(id: self.email, name: self.name, email: self.email, password: self.password)
    }
}

extension FirebaseAdaptedUser {
    fileprivate func toItem() -> User {
        User(name: self.name, email: self.email, password: self.password)
    }
}
