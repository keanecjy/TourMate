//
//  User.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation

struct User: CustomStringConvertible {
    let id: String
    let name: String
    let email: String
    let imageUrl: String

    static func defaultUser() -> User {
        User(id: "0", name: "Empty", email: "", imageUrl: "")
    }
}

// MARK: - CustomStringConvertible
extension User {
    public var description: String {
        "User: (id: \(id), name: \(name))"
    }

}
