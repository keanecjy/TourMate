//
//  CommentService.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

protocol CommentService {
    func fetchCommentsAndListen(withPlanId planId: String) async

    func addComment(comment: Comment) async -> (Bool, String)

    func deleteComment(comment: Comment) async -> (Bool, String)

    func updateComment(comment: Comment) async -> (Bool, String)

    var commentEventDelegate: CommentEventDelegate? { get set }

    func detachListener()
}
