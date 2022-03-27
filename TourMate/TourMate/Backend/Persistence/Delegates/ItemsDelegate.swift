//
//  ItemsDelegate.swift
//  TourMate
//
//  Created by Keane Chan on 26/3/22.
//

protocol ItemsDelegate: AnyObject {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async
}
