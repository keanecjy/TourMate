//
//  FirebaseAdaptedData.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation

protocol FirebaseAdaptedData: Codable {
    static var type: FirebaseAdaptedType { get }
    var id: String { get }
}
