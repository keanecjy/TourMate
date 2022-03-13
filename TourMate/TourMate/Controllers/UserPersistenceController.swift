//
//  UserPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation

struct UserPersistenceController {
    let firebasePersistenceManager =
    FirebasePersistenceManager<FirebaseAdaptedUser>(collectionId: FirebaseConfig.userCollectionId)
    
    func addUser(name: String, email: String, password: String) async -> (hasAddedItem: Bool, errorMessage: String) {
        let user = User(id: UUID().uuidString, name: name, email: email, password: password)
        let adaptedUser = user.toData()
        return await firebasePersistenceManager.addItem(item: adaptedUser)
    }

    func getUser(email: String) async -> (user: User?, errorMessage: String) {
        let (adaptedUsers, error)  = await firebasePersistenceManager.fetchItems(field: "email", id: email)
        guard let adapterUser = adaptedUsers.first else {
            return (nil, error)
        }
        
        return (adapterUser.toItem(), error)
    }
    
    func deleteUser(user: User)
}

fileprivate extension User {
    func toData() -> FirebaseAdaptedUser {
        FirebaseAdaptedUser(id: self.email, name: self.name, email: self.email, password: self.password)
    }
}

fileprivate extension FirebaseAdaptedUser {
    func toItem() -> User {
        User(id: self.id!, name: self.name, email: self.email, password: self.password)
    }
}
