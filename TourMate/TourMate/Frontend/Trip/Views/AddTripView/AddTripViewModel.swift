//
//  AddTripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import Foundation
import Combine

@MainActor
class AddTripViewModel: TripFormViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    let tripService: TripService
    let userService: UserService

    init(tripService: TripService, userService: UserService) {
        self.tripService = tripService
        self.userService = userService

        super.init()
    }

    func addTrip() async {
        self.isLoading = true
        let (user, userErrorMessage) = await userService.getCurrentUser()
        guard let user = user, userErrorMessage.isEmpty else {
            handleError()
            return
        }

        let creatorUserId = user.id
        let uuid = UUID().uuidString
        let name = tripName
        let imageUrl = tripImageURL

        let (startDateTime, endDateTime) = generateDateTimes()

        let newTrip = Trip(id: uuid,
                           name: name,
                           startDateTime: startDateTime,
                           endDateTime: endDateTime,
                           imageUrl: imageUrl,
                           creatorUserId: creatorUserId)

        let (hasAddedTrip, tripErrorMessage) = await tripService.addTrip(trip: newTrip)
        guard hasAddedTrip, tripErrorMessage.isEmpty else {
            handleError()
            return
        }
        self.isLoading = false
    }

}

// MARK: - Helper Methods
extension AddTripViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }
}
