//
//  TripsDelegate.swift
//  TourMate
//
//  Created by Keane Chan on 26/3/22.
//

protocol TripsDelegate: AnyObject {
    func update(trips: [Trip], errorMessage: String) async
}
