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

    @Published var suggestedLocations: [Location] = []
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
        if query.isEmpty {
            suggestedLocations = []
            task?.cancel()
            return
        }

        task?.cancel()

        task = Task {
            await Task.sleep(seconds: 1)

            if Task.isCancelled {
                return
            }

            let (suggestedLocations, errorMessage) = await locationService.fetchLocations(query: query)

            guard errorMessage.isEmpty else {
                self.hasError = true
                print("[SearchViewModel] Error: \(errorMessage)")
                return
            }
            self.suggestedLocations = suggestedLocations
        }
    }
}
