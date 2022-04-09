//
//  LocationWebRepository.swift
//  TourMate
//
//  Created by Tan Rui Quan on 30/3/22.
//

import Foundation
import Combine

protocol LocationWebRepository: WebRepository {
    func fetchLocations(query: AutocompleteQuery) async -> (locations: [JsonAdaptedLocation], errorMessage: String)

    func fetchLocations(query: AutocompleteQuery) -> AnyPublisher<[JsonAdaptedLocation], Error>
}
