//
//  FirebaseUserService.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation
import FirebaseAuth

struct FirebaseUserService: UserService {
    @Injected(\.userRepository) var userRepository: Repository

    private let userAdapter = UserAdapter()

    func addUser(_ user: User) async -> (Bool, String) {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email,
              email == user.email
        else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        let adaptedUser = userAdapter.toAdaptedUser(user: user)
        return await userRepository.addItem(id: currentUser.uid, item: adaptedUser)
    }

    func deleteUser() async -> (Bool, String) {
        guard let currentUser = Auth.auth().currentUser else {
            return (false, Constants.messageUserNotLoggedIn)
        }
        return await userRepository.deleteItem(id: currentUser.uid)
    }

    func getCurrentUser() async -> (User?, String) {
        guard let currentUser = Auth.auth().currentUser else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        return await getUser(withUserId: currentUser.uid)
    }

    func getUser(withUserId userId: String) async -> (User?, String) {
        let (adaptedUser, errorMessage) = await userRepository.fetchItem(id: userId)

        guard errorMessage.isEmpty else {
            return (nil, errorMessage)
        }

        guard let adaptedUser = adaptedUser as? FirebaseAdaptedUser else {
            return (nil, errorMessage) // user not found
        }

        return (userAdapter.toUser(adaptedUser: adaptedUser), errorMessage)
    }

    func getUser(withEmail email: String) async -> (User?, String) {
        guard Auth.auth().currentUser != nil else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        let (adaptedUsers, errorMessage) = await userRepository.fetchItems(field: "email", isEqualTo: email)

        guard errorMessage.isEmpty else {
            return (nil, errorMessage)
        }

        // should not have more than 1 user with the same email
        guard adaptedUsers.count <= 1 else {
            assertionFailure()
            return (nil, "More than one user found")
        }

        guard let adaptedUser = adaptedUsers.first as? FirebaseAdaptedUser else {
            return (nil, errorMessage) // user not found
        }

        return (userAdapter.toUser(adaptedUser: adaptedUser), "")
    }

}
