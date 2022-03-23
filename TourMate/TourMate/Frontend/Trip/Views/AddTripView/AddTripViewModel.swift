//
//  AddTripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import Foundation
import Combine

@MainActor
class AddTripViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    @Published var tripName = ""
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var imageUrl = ""
    @Published var isTripNameValid = false
    @Published var isTripDurationValid = true
    @Published var canAddTrip = false

    var invalidDurationPrompt: String {
        isTripDurationValid ? "" : "Start date can not be after end data"
    }

    let tripController: TripController
    let userController: UserController

    private var cancellableSet: Set<AnyCancellable> = []

    init(tripController: TripController = FirebaseTripController(),
         userController: UserController = FirebaseUserController()) {
        self.tripController = tripController
        self.userController = userController

        $tripName
            .map({ !$0.isEmpty })
            .assign(to: \.isTripNameValid, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($startDate, $endDate)
            .map({ $0 <= $1 })
            .assign(to: \.isTripDurationValid, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($isTripNameValid, $isTripDurationValid)
            .map({ $0 && $1 })
            .assign(to: \.canAddTrip, on: self)
            .store(in: &cancellableSet)
    }

    func addTrip() async {
        self.isLoading = true
        let (user, userErrorMessage) = await userController.getUser()
        guard let user = user, userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        let uuid = UUID().uuidString
        let trip = Trip(id: uuid,
                        name: tripName,
                        startDate: startDate,
                        endDate: endDate,
                        imageUrl: imageUrl,
                        creatorUserId: user.id)
        let (hasAddedTrip, tripErrorMessage) = await tripController.addTrip(trip: trip)
        guard hasAddedTrip == true, tripErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

}
