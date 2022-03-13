//
//  FirebaseAdaptedData.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

protocol FirebaseAdaptedData: Codable {
    static var type: FirebaseAdaptedType { get }
    var id: String { get set }
}
