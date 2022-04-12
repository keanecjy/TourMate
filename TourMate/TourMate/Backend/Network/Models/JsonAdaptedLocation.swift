//
//  JsonAdaptedLocation.swift
//  TourMate
//
//  Created by Tan Rui Quan on 30/3/22.
//

import Foundation

struct JsonAdaptedLocation: Codable {
    let country: String
    let address_line1: String
    let address_line2: String
    // formatted = address_line1 + address_line2
    let formatted: String
    let lon: Double
    let lat: Double
}
