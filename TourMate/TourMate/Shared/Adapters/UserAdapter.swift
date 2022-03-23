//
//  UserAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 23/3/22.
//

class UserAdapter {
    init() {}

    func toAdaptedUser(user: User) -> FirebaseAdaptedUser {
        user.toData()
    }

    func toUser(adaptedUser: FirebaseAdaptedUser) -> User {
        adaptedUser.toItem()
    }
}

extension User {
    fileprivate func toData() -> FirebaseAdaptedUser {
        FirebaseAdaptedUser(id: id, name: name, email: email, imageUrl: imageUrl)
    }
}

extension FirebaseAdaptedUser {
    fileprivate func toItem() -> User {
        User(id: id, name: name, email: email, imageUrl: imageUrl)
    }
}
