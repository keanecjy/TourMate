//
//  FirebaseEventDelegate.swift
//  TourMate
//
//  Created by Keane Chan on 26/3/22.
//

protocol FirebaseEventDelegate: AnyObject {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async

    func update(item: FirebaseAdaptedData?, errorMessage: String) async
}
