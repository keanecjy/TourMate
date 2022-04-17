//
//  NearbyPlacesViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import Foundation

@MainActor
class NearbyPlacesViewModel: ObservableObject {
    @Published private(set) var hasError: Bool
    @Published private(set) var isLoading: Bool

    @Published var suggestions: [NearbyPlace]

    let plans: [Plan]
    private var placeService: PlaceService

    init(plans: [Plan], placeService: PlaceService) {
        self.hasError = false
        self.isLoading = false

        self.suggestions = []

        self.plans = plans
        self.placeService = placeService
    }

    func fetchNearbyPlaces() async {
        let locations = getLocations()
        if locations.isEmpty {
            return
        }

        self.isLoading = true

        var result = [NearbyPlace]()
        for location in locations {
            let (suggestions, errorMessage) = await placeService.fetchTourismPlaces(near: location)

            guard errorMessage.isEmpty else {
                self.hasError = true
                self.isLoading = false
                return
            }
            result.append(contentsOf: suggestions)
        }
        self.suggestions = Array(Set(result))
    }

    private func getLocations() -> [Location] {
        var result = [Location]()
        for plan in plans {
            switch plan {
            case let activity as Activity:
                if activity.location.isPresent() { result.append(activity.location) }
            case let accommodation as Accommodation:
                if accommodation.location.isPresent() { result.append(accommodation.location) }
            default:
                continue
            }
        }
        return result
    }
}
