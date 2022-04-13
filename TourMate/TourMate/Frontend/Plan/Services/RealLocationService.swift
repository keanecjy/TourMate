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
        let autocompleteQuery = AutocompleteQuery(apiKey: ApiKeys.geopifyApiKey, text: query)
        return await fetchSuggestions(query: autocompleteQuery)
    }

    func fetchLocations(query: String, near location: Location) async -> ([Location], String) {
        let bias = "proximity:\(location.longitude),\(location.latitude)"
        let autocompleteQuery = AutocompleteQuery(apiKey: ApiKeys.geopifyApiKey, text: query, bias: bias)
        return await fetchSuggestions(query: autocompleteQuery)
    }

    func fetchCities(query: String) async -> ([Location], String) {
        let autocompleteQuery = AutocompleteQuery(apiKey: ApiKeys.geopifyApiKey, text: query, type: "city")
        return await fetchSuggestions(query: autocompleteQuery)

    }

    private func fetchSuggestions(query: AutocompleteQuery) async -> ([Location], String) {
        let (adaptedLocations, errorMessage) = await locationWebRepository.fetchLocations(query: query)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        let locations = adaptedLocations
            .map({ locationAdapter.toLocation(adaptedLocation: $0) })
        return (locations, "")
    }
}
