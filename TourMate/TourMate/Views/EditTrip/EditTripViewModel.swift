//
//  EditTripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import Foundation

@MainActor
class EditTripViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool
    let tripController: TripController
    let userController: UserPersistenceController

    init(tripController: TripController = FirebaseTripController(),
         userController: UserPersistenceController = UserPersistenceController()) {
        self.isLoading = false
        self.hasError = false
        self.tripController = tripController
        self.userController = userController
    }

    private func modifyTrip(id: String,
                            name: String,
                            startDate: Date,
                            endDate: Date,
                            imageUrl: String? = nil,
                            function: (Trip) async -> (Bool, String)) async {
        self.isLoading = true
        let (user, userErrorMessage) = await userController.getUser()
        guard let user = user, userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        let trip = Trip(id: id,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        imageUrl: imageUrl,
                        creatorUserId: user.id)
        let (hasUpdatedTrip, tripErrorMessage) = await function(trip)
        guard hasUpdatedTrip, tripErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

    func updateTrip(id: String,
                    name: String,
                    startDate: Date,
                    endDate: Date,
                    imageUrl: String? = nil) async {
        await modifyTrip(id: id, name: name, startDate: startDate, endDate: endDate) { trip in
            await tripController.updateTrip(trip: trip)
        }
    }

    func deleteTrip(id: String,
                    name: String,
                    startDate: Date,
                    endDate: Date,
                    imageUrl: String? = nil) async {
        await modifyTrip(id: id, name: name, startDate: startDate, endDate: endDate) { trip in
            await tripController.deleteTrip(trip: trip)
        }
    }
}
