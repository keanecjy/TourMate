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

    private let locationService: LocationService

    private var cancellableSet: Set<AnyCancellable> = []

    init(locationService: LocationService) {
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
        fetchSuggestions(action: locationService.fetchLocations,
                         query: locationQuery)
    }

    func fetchCities() {
        fetchSuggestions(action: locationService.fetchCities,
                         query: cityQuery)
    }

    private func fetchSuggestions(action: @escaping (String) async -> ([Location], String), query: String) {
        if locationQuery.isEmpty,
           cityQuery.isEmpty {
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

            let (suggestions, errorMessage) = await action(query)

            guard errorMessage.isEmpty else {
                self.hasError = true
                print("[SearchViewModel] Error: \(errorMessage)")
                return
            }
            self.suggestions = suggestions
        }
    }
}
