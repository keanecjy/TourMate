//
//  MapViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 2/4/22.
//

import Foundation
import Combine
import MapKit

// Not used
@MainActor
class MapViewModel: ObservableObject {
    @Published var location: Location
    @Published var region = MKCoordinateRegion()
    @Published var annotations = [CLLocationCoordinate2D]()

    private var cancellableSet: Set<AnyCancellable> = []

    init(location: Location) {
        self.location = location
        addSubscriptions()
    }

    private func addSubscriptions() {
        $location
            .map({
                let center = CLLocationCoordinate2D(
                    latitude: $0.latitude,
                    longitude: $0.longitude)
                return MKCoordinateRegion(
                    center: center,
                    latitudinalMeters: 750,
                    longitudinalMeters: 750
                )
            })
            .assign(to: \.region, on: self)
            .store(in: &cancellableSet)

        $location
            .map({
                let center = CLLocationCoordinate2D(
                    latitude: $0.latitude,
                    longitude: $0.longitude)
                return [center]
            })
            .assign(to: \.annotations, on: self)
            .store(in: &cancellableSet)
    }
}
