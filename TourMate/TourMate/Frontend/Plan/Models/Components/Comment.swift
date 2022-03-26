//
//  Comments.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import Foundation

struct Comment {
    let planId: String
    let id: String
    let name: String
    let message: String
    let creationDate: Date
    var upvotedUserIds: [String]
}
