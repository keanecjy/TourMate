//
//  LocationSelectionViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import Foundation

@MainActor
class LocationSelectionViewModel {
    var locations: [Location]
    private let plans: [Plan]

    init(plans: [Plan]) {
        self.locations = []
        self.plans = plans
        self.locations = getLocations(plans)
    }

    private func getLocations(_ plans: [Plan]) -> [Location] {
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
