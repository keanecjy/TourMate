//
//  FirebaseUserController.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation
import FirebaseAuth

struct FirebaseUserController: UserController {
    private let firebasePersistenceManager = FirebasePersistenceManager(
        collectionId: FirebaseConfig.userCollectionId)

    private let userAdapter = UserAdapter()

    func addUser(_ user: User) async -> (Bool, String) {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email,
              email == user.email
        else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        let adaptedUser = userAdapter.toAdaptedUser(user: user)
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

        guard let adaptedUser = adaptedUser as? FirebaseAdaptedUser else {
            preconditionFailure()
        }

        return (userAdapter.toUser(adaptedUser: adaptedUser), errorMessage)
    }

    func getUser(email: String) async -> (User?, String) {
        guard Auth.auth().currentUser != nil else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        let (adaptedUsers, errorMessage) = await firebasePersistenceManager.fetchItems(field: "email", isEqualTo: email)

        guard errorMessage.isEmpty else {
            return (nil, errorMessage)
        }

        // should not have more than 1 user with the same email
        guard adaptedUsers.count <= 1 else {
            preconditionFailure()
        }

        guard let adaptedUser = adaptedUsers.first as? FirebaseAdaptedUser else {
            return (nil, "") // user not found
        }

        return (userAdapter.toUser(adaptedUser: adaptedUser), "")
    }

}
