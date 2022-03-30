//
//  TripEventDelegate.swift
//  TourMate
//
//  Created by Keane Chan on 26/3/22.
//

protocol TripEventDelegate: AnyObject {
    func update(trips: [Trip], errorMessage: String) async

    func update(trip: Trip?, errorMessage: String) async
}
