//
//  PlaceService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import Foundation

protocol PlaceService {
    func fetchTourismPlaces(near: Location) async -> ([NearbyPlace], String)
}
