//
//  SearchViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import SwiftUI
import Combine

///https://iosexample.com/autocomplete-for-a-text-field-in-swiftui-using-async-await/
@MainActor
class SearchViewModel: ObservableObject {
    @Published private(set) var hasError = false

    @Published var suggestions: [Location] = []
    @Published var locationQuery: String = ""
    @Published var cityQuery: String = ""

    private let location: Location?
    private let locationService: LocationService

    private var cancellableSet: Set<AnyCancellable> = []

    init(locationService: LocationService, location: Location? = nil) {
        self.location = location
        self.locationService = locationService
        addSubscriptions()
    }

    func addSubscriptions() {
        $locationQuery.sink { [unowned self] _ in
            self.fetchLocations()
        }
        .store(in: &cancellableSet)

        $cityQuery.sink { [unowned self] _ in
            self.fetchCities()
        }
        .store(in: &cancellableSet)
    }

    private var task: Task<Void, Never>?

    func fetchLocations() {
        if locationQuery.isEmpty {
            suggestions = []
            task?.cancel()
            return
        }

        task?.cancel()

        task = Task {
            await Task.sleep(seconds: 0.5)

            if Task.isCancelled {
                return
            }

            var suggestions: [Location]
            var errorMessage: String
            if let location = location {
                (suggestions, errorMessage) = await locationService.fetchLocations(query: locationQuery, near: location)
            } else {
                (suggestions, errorMessage) = await locationService.fetchLocations(query: locationQuery)
            }

            guard errorMessage.isEmpty else {
                self.hasError = true
                print("[SearchViewModel] Error: \(errorMessage)")
                return
            }
            self.suggestions = suggestions
        }
    }

    func fetchCities() {
        if cityQuery.isEmpty {
            suggestions = []
            task?.cancel()
            return
        }

        task?.cancel()

        task = Task {
            await Task.sleep(seconds: 0.5)

            if Task.isCancelled {
                return
            }

            let (suggestions, errorMessage) = await locationService.fetchCities(query: cityQuery)

            guard errorMessage.isEmpty else {
                self.hasError = true
                print("[SearchViewModel] Error: \(errorMessage)")
                return
            }
            self.suggestions = suggestions
        }
    }
}
