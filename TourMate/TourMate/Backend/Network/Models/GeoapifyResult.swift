//
//  GeoapifyResult.swift
//  TourMate
//
//  Created by Tan Rui Quan on 30/3/22.
//

import Foundation

struct GeoapifyResult: Codable {
    let results: [JsonAdaptedLocation]
}
