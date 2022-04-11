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

    private(set) var canDeleteTrip = false

    private let trip: Trip

    private let tripService: TripService
    private let userService: UserService

    init(trip: Trip, tripService: TripService, userService: UserService) {
        self.trip = trip

        self.tripService = tripService
        self.userService = userService

        super.init(trip: trip)
    }

    private func updatePermissions() {
        Task {
            let (currentUser, _) = await userService.getCurrentUser()
            if let currentUser = currentUser,
                currentUser.id == trip.creatorUserId {
                setSpecialPermissions(true)
            } else {
                setSpecialPermissions(false)
            }
        }
    }

    private func setSpecialPermissions(_ allowed: Bool) {
        canDeleteTrip = allowed
    }

    func updateTrip() async {
        self.isLoading = true

        let id = trip.id
        let name = tripName
        let imageUrl = tripImageURL
        let creatorUserId = trip.creatorUserId
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
                               creatorUserId: creatorUserId,
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
