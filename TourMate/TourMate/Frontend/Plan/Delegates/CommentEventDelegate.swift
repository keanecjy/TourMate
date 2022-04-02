//
//  CommentEventDelegate.swift
//  TourMate
//
//  Created by Keane Chan on 31/3/22.
//

protocol CommentEventDelegate: AnyObject {
    func update(comments: [Comment], errorMessage: String) async
}
