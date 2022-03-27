//
//  CommentController.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

protocol CommentService {
    func fetchComments(withPlanId planId: String) async -> ([Comment], String)

    func fetchComment(withCommentId id: String) async -> (Comment?, String)

    func addComment(comment: Comment) async -> (Bool, String)

    func deleteComment(comment: Comment) async -> (Bool, String)

    func updateComment(comment: Comment) async -> (Bool, String)
}
