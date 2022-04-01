//
//  AddTripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
class AddTripViewModel: TripFormViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    let tripService: TripService
    let userService: UserService

    init(tripService: TripService = FirebaseTripService(),
         userService: UserService = FirebaseUserService()) {
        self.tripService = tripService
        self.userService = userService

        super.init()
    }

    func addTrip() async {
        self.isLoading = true
        let (user, userErrorMessage) = await userService.getUser()

        guard let user = user, userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
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
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

}
