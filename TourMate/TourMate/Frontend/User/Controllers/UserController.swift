//
//  UserController.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation

protocol UserController {
    func addUser(_ user: User) async -> (Bool, String)

    func deleteUser() async -> (Bool, String)

    func getUser() async -> (User?, String)

    func getUser(email: String) async -> (User?, String)
}
