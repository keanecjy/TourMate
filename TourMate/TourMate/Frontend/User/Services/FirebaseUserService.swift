//
//  FirebaseUserService.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation

struct FirebaseUserService: UserService {
    private let userRepository = FirebaseRepository(collectionId: FirebaseConfig.userCollectionId)
    @Injected(\.authenticationService) var authenticationService: AuthenticationService

    private let userAdapter = UserAdapter()

    func addUser(_ user: User) async -> (Bool, String) {
        guard let currentUser = authenticationService.getCurrentAuthenticatedUser(),
              currentUser.email == user.email
        else {
            return (false, Constants.messageUserNotLoggedIn)
        }

        let adaptedUser = userAdapter.toAdaptedUser(user: user)
        return await userRepository.addItem(id: currentUser.id, item: adaptedUser)
    }

    func deleteUser() async -> (Bool, String) {
        guard let currentUser = authenticationService.getCurrentAuthenticatedUser() else {
            return (false, Constants.messageUserNotLoggedIn)
        }
        return await userRepository.deleteItem(id: currentUser.id)
    }

    func getCurrentUser() async -> (User?, String) {
        guard let currentUser = authenticationService.getCurrentAuthenticatedUser() else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        return await getUser(withUserId: currentUser.id)
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
        guard authenticationService.hasLoggedInUser() else {
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
