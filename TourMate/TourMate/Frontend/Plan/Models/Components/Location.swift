//
//  Location.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import Foundation

struct Location: Equatable {
    var country: String = ""
    var city: String = ""
    var addressLineOne: String = ""
    var addressLineTwo: String = ""
    // full = address line one + address line two
    var addressFull: String = ""
    var longitude: Double = 0.0
    var latitude: Double = 0.0
}

extension Location: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}
