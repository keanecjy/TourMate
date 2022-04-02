//
//  RealLocationService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 31/3/22.
//

import Foundation

struct RealLocationService: LocationService {
    private let locationWebRepository = RealLocationWebRepository(baseURL: ApiConfig.geoapifyBaseUrl)

    private let locationAdapter = LocationAdapter()

    func fetchLocations(query: String) async -> ([Location], String) {
        print("[LocationService] Fetching Locations")

        let autocompleteQuery = AutocompleteQuery(apiKey: ApiKeys.geopifyApiKey, text: query)

        let (adaptedLocations, errorMessage) = await locationWebRepository.fetchLocations(query: autocompleteQuery)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        let locations = adaptedLocations
            .map({ locationAdapter.toLocation(adaptedLocation: $0) })
        return (locations, "")
    }
}
