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
    @Published var query: String = ""

    private let locationService: LocationService

    private var cancellableSet: Set<AnyCancellable> = []

    init(locationService: LocationService) {
        self.locationService = locationService
        addSubscriptions()
    }

    func addSubscriptions() {
        $query.sink { [unowned self] _ in
            self.fetchLocations()
        }
        .store(in: &cancellableSet)
    }

    private var task: Task<Void, Never>?

    func fetchLocations() {
        fetchSuggestions(action: locationService.fetchLocations)
    }

    func fetchCities() {
        fetchSuggestions(action: locationService.fetchCities)
    }

    private func fetchSuggestions(action: @escaping (String) async -> ([Location], String)) {
        if query.isEmpty {
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

            let (suggestedLocations, errorMessage) = await action(query)

            guard errorMessage.isEmpty else {
                self.hasError = true
                print("[SearchViewModel] Error: \(errorMessage)")
                return
            }
            self.suggestions = suggestedLocations
        }
    }
}
