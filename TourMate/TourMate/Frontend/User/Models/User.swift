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
        User(id: "Not found", name: "Not found", email: "Not found", imageUrl: "Not found")
    }
}

// MARK: - CustomStringConvertible
extension User {
    public var description: String {
        "User: (id: \(id), name: \(name))"
    }

}
