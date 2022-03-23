//
//  AddTripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import Foundation

@MainActor
class AddTripViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool
    let tripController: TripController
    let userController: UserController

    init(tripController: TripController = FirebaseTripController(),
         userController: UserController = FirebaseUserController()) {
        self.isLoading = false
        self.hasError = false
        self.tripController = tripController
        self.userController = userController
    }

    func addTrip(name: String, startDate: Date, endDate: Date, imageUrl: String? = nil) async {
        self.isLoading = true
        let (user, userErrorMessage) = await userController.getUser()
        guard let user = user, userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        let uuid = UUID().uuidString
        let trip = Trip(id: uuid,
                        name: name,
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
