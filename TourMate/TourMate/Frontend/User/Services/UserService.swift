//
//  UserService.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation

protocol UserService {
    func addUser(_ user: User) async -> (Bool, String)

    func deleteUser() async -> (Bool, String)

    func getCurrentUser() async -> (User?, String)

    func getUser(withUserId userId: String) async -> (User?, String)

    func getUser(withEmail email: String) async -> (User?, String)
}
