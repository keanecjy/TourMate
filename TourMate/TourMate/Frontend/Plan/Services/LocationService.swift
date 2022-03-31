//
//  LocationService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import Foundation

protocol LocationService {
    func fetchLocations(query: String) async -> ([Location], String)
}
