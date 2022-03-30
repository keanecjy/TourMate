//
//  FirebaseUserService.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation
import FirebaseAuth

struct FirebaseUserService: UserService {
    private let firebaseRepository = FirebaseRepository(
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
        return await firebaseRepository.addItem(id: currentUser.uid, item: adaptedUser)
    }

    func deleteUser() async -> (Bool, String) {
        guard let currentUser = Auth.auth().currentUser else {
            return (false, Constants.messageUserNotLoggedIn)
        }
        return await firebaseRepository.deleteItem(id: currentUser.uid)
    }

    // TODO: Rename to getCurrentUser, and add a new method to get user by id
    func getUser() async -> (User?, String) {
        guard let currentUser = Auth.auth().currentUser else {
            return (nil, Constants.messageUserNotLoggedIn)
        }
        let (adaptedUser, errorMessage) = await firebaseRepository.fetchItem(id: currentUser.uid)

        guard errorMessage.isEmpty else {
            return (nil, errorMessage)
        }

        guard let adaptedUser = adaptedUser as? FirebaseAdaptedUser else {
            assertionFailure()
            return (nil, "") // user not found
        }

        return (userAdapter.toUser(adaptedUser: adaptedUser), errorMessage)
    }

    func getUser(with field: String, value: String) async -> (User?, String) {
        guard Auth.auth().currentUser != nil else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        let (adaptedUsers, errorMessage) = await firebaseRepository.fetchItems(field: field, isEqualTo: value)

        guard errorMessage.isEmpty else {
            return (nil, errorMessage)
        }

        // should not have more than 1 user with the same email
        guard adaptedUsers.count <= 1 else {
            assertionFailure()
            return (nil, "More than one user found")
        }

        guard let adaptedUser = adaptedUsers.first as? FirebaseAdaptedUser else {
            return (nil, "") // user not found
        }

        return (userAdapter.toUser(adaptedUser: adaptedUser), "")
    }

}
