//
//  UpvoteEventDelegate.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

protocol PlanUpvoteEventDelegate: AnyObject {
    func update(planUpvotes: [PlanUpvote], errorMessage: String) async
}
