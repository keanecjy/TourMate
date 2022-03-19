//
//  FirebaseAdaptedData.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation

protocol FirebaseAdaptedData: Codable {
    func getType() -> FirebaseAdaptedType
    var id: String { get }
}
