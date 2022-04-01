//
//  EditTripViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 1/4/22.
//

import Foundation

@MainActor
class EditTripViewModel: TripFormViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    @Published var trip: Trip

    private var tripService: TripService
    private let userService: UserService

    init(trip: Trip,
         tripService: TripService = FirebaseTripService(),
         userService: UserService = FirebaseUserService()) {

        self.trip = trip

        self.tripService = tripService
        self.userService = userService

        super.init(trip: trip)
    }

    func updateTrip() async {
        self.isLoading = true

        let id = trip.id
        let name = tripName
        let imageUrl = tripImageURL
        let attendeesUserIds = trip.attendeesUserIds
        let invitedUserIds = trip.invitedUserIds
        let creationDate = trip.creationDate

        let (startDateTime, endDateTime) = generateDateTimes(startTimeZone: trip.startDateTime.timeZone,
                                                             endTimeZone: trip.endDateTime.timeZone)

        let updatedTrip = Trip(id: id,
                               name: name,
                               startDateTime: startDateTime,
                               endDateTime: endDateTime,
                               imageUrl: imageUrl,
                               attendeesUserIds: attendeesUserIds,
                               invitedUserIds: invitedUserIds,
                               creationDate: creationDate,
                               modificationDate: Date())

        let (hasUpdated, errorMessage) = await tripService.updateTrip(trip: updatedTrip)
        guard hasUpdated, errorMessage.isEmpty else {
            handleError()
            return
        }
        self.isLoading = false
    }

    func deleteTrip() async {
        self.isLoading = true
        let (hasDeleted, errorMessage) = await tripService.deleteTrip(trip: trip)
        guard hasDeleted, errorMessage.isEmpty else {
            handleError()
            return
        }
        handleDeletion()
    }
}

// MARK: - State changes
extension EditTripViewModel {
    private func handleDeletion() {
        self.isDeleted = true
        self.isLoading = false
    }

    private func handleError() {
        self.isLoading = false
        self.hasError = true
    }

}
