//
//  TransportationOptionsViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 16/4/22.
//

import SwiftUI
import Combine

@MainActor
class TransportationOptionsViewModel: ObservableObject {
    @Published private(set) var hasError: Bool
    @Published private(set) var isLoading: Bool

    @Published var fromLocation: Location
    @Published var toLocation: Location
    @Published var suggestions: [RoutingResult]

    let plans: [Plan]
    private var routingService: RoutingService

    private var cancellableSet: Set<AnyCancellable> = []

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
        Publishers
            .CombineLatest($fromLocation, $toLocation)
            .sink { [unowned self] fromLocation, toLocation in
                self.fetchTransportationOptions(fromLocation, toLocation)
            }
            .store(in: &cancellableSet)
    }

    private var task: Task<Void, Never>?

    func fetchTransportationOptions(_ fromLocation: Location, _ toLocation: Location) {
        print("[TransportationOptionsViewModel] Fetch called")
        if !fromLocation.isPresent() || !toLocation.isPresent() {
            suggestions = []
            task?.cancel()
            print("[TransportationOptionsViewModel] not present")
            return
        }

        task?.cancel()

        task = Task {
            await Task.sleep(seconds: 0.5)

            if Task.isCancelled {
                return
            }

            let (suggestions, errorMessage) =
            await routingService.fetchTransportationOptions(from: fromLocation, to: toLocation)

            guard errorMessage.isEmpty else {
                self.hasError = true
                print("[TransportationOptionsViewModel] Error")
                return
            }
            print("[TransportationOptionsViewModel] suggestions: \(suggestions)")
            self.suggestions = suggestions
        }
    }

    func getSymbolString(_ mode: TravelMode) -> String {
        switch mode {
        case .drive:
            return "car.circle.fill"
        case .transit:
            return "tram.circle.fill"
        case .walk:
            return "figure.walk.circle.fill"
        case .bicycle:
            return "bicycle.circle.fill"
        }
    }
}
