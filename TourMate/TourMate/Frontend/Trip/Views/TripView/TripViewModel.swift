//
//  TripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation
import Combine

@MainActor
class TripViewModel: ObservableObject {

    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    @Published var attendees: [User] = []
    @Published var trip: Trip

    @Injected(\.tripService) var tripService: TripService
    @Injected(\.userService) var userService: UserService

    init(trip: Trip) {
        self.trip = trip
    }

    var tripId: String {
        trip.id
    }

    var nameDisplay: String {
        trip.name
    }

    var startDateTime: DateTime {
        trip.startDateTime
    }

    var endDateTime: DateTime {
        trip.endDateTime
    }

    var durationDisplay: String {
        trip.durationDescription
    }

    var imageUrlDisplay: String {
        trip.imageUrl
    }

    func fetchTripAndListen() async {
        tripService.tripEventDelegate = self

        self.isLoading = true
        await tripService.fetchTripAndListen(withTripId: trip.id)
    }

    func detachListener() {
        tripService.tripEventDelegate = nil

        self.isLoading = false
        tripService.detachListener()
    }

    func inviteUser(email: String) async {
        self.isLoading = true

        // fetch user
        let (user, userErrorMessage) = await userService.getUser(withEmail: email)

        guard userErrorMessage.isEmpty else {
            handleError()
            return
        }

        guard let user = user else { // user not null
            print("[TripViewModel] Email is not a registered account")
            self.isLoading = false
            return
        }

        let userId = user.id

        // user not in trip
        guard !trip.attendeesUserIds.contains(userId) else {
            print("[TripViewModel] User already invited")
            self.isLoading = false
            return
        }

        trip.attendeesUserIds.append(userId)

        let (hasUpdated, updateErrorMessage) = await tripService.updateTrip(trip: trip)
        guard hasUpdated, updateErrorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }

    private func fetchAttendees() async {
        var fetchedAttendees: [User] = []

        for userId in trip.attendeesUserIds {
            let (user, userErrorMessage) = await userService.getUser(withUserId: userId)

            guard userErrorMessage.isEmpty else {
                handleError()
                return
            }

            guard let user = user else { // user not null
                print("No user exists with id \(userId)")
                handleError()
                return
            }

            fetchedAttendees.append(user)
        }

        self.attendees = fetchedAttendees
    }
}

// MARK: - TripsEventDelegate
extension TripViewModel: TripEventDelegate {
    func update(trip: Trip?, errorMessage: String) async {
        print("[TripViewModel] Updating Single Trip")

        guard let trip = trip else {
            handleDeletion()
            return
        }

        guard errorMessage.isEmpty else {
            handleError()
            return
        }

        self.trip = trip
        await fetchAttendees()

        self.isLoading = false
    }

    func update(trips: [Trip], errorMessage: String) async {}
}

// MARK: - State changes
extension TripViewModel {
    private func handleDeletion() {
        self.isDeleted = true
        self.isLoading = false
    }

    private func handleError() {
        self.isLoading = false
        self.hasError = true
    }

}
