//
//  MockUserController.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

class MockUserController: UserController {

    var users: [User] = [
        User(id: "0", name: "Tester 0",
             email: "Tester0@gmail.com", imageUrl: "https://nationaltoday.com/wp-content/uploads/2021/06/International-Corgi-Day-1.jpg"),
        User(id: "1", name: "Tester 1",
             email: "Tester1@gmail.com", imageUrl: "https://www.purina.com.au/-/media/project/purina/main/breeds/puppies/puppy-chihuahua/puppy-corgi.jpg")
    ]

    func addUser(_ user: User) async -> (Bool, String) {
        users.append(user)
        return (true, "")
    }

    func deleteUser() async -> (Bool, String) {
        return (true, "")
    }

    func getUser() async -> (User?, String) {
        return (nil, "")
    }

    func getUser(with field: String, value: String) async -> (User?, String) {
        guard field == "id" else {
            return (nil, "")
        }

        let filteredUsers = users.filter({ $0.id == value })

        return (filteredUsers.first, "")
    }
}
