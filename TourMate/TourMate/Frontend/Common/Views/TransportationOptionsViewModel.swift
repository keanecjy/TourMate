//
//  TransportationOptionsViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 16/4/22.
//

import Foundation

@MainActor
class TransportationOptionsViewModel: ObservableObject {
    @Published private(set) var hasError: Bool
    @Published private(set) var isLoading: Bool

    @Published var fromLocation: Location
    @Published var toLocation: Location
    @Published var suggestions: [RoutingResult]

    let plans: [Plan]
    private var routingService: RoutingService

    init(plans: [Plan], routingService: RoutingService) {
        self.hasError = false
        self.isLoading = false

        self.fromLocation = Location()
        self.toLocation = Location()
        self.suggestions = []

        self.plans = plans
        self.routingService = routingService
        addSubscriptions()
    }

    private func addSubscriptions() {
        print("implement add subscriptions")
    }

    private var task: Task<Void, Never>?

    func fetchTransportationOptions() {
        if !fromLocation.isPresent() || !toLocation.isPresent() {
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

            let (suggestions, errorMessage) = await routingService.fetchTransportationOptions(from: fromLocation, to: toLocation)

            guard errorMessage.isEmpty else {
                self.hasError = true
                print("[TransportationOptionsViewModel] Error")
                return
            }
            self.suggestions = suggestions
        }
    }
}
