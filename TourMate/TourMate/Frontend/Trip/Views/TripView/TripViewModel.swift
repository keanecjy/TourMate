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
    @Published var trip: Trip
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    @Published var isTripNameValid = true
    @Published var fromStartDate = Date()...
    @Published var canUpdateTrip = true

    @Published var attendees: [User] = []

    let tripService: TripService
    let userService: UserService

    private var cancellableSet: Set<AnyCancellable> = []

    init(trip: Trip,
         tripService: TripService = FirebaseTripService(),
         userService: UserService = FirebaseUserService()) {

        self.trip = trip
        self.tripService = tripService
        self.userService = userService

        $trip
            .map({ $0.name })
            .map({ !$0.isEmpty })
            .assign(to: \.isTripNameValid, on: self)
            .store(in: &cancellableSet)

        $trip
            .map({ $0.startDateTime.date... })
            .assign(to: \.fromStartDate, on: self)
            .store(in: &cancellableSet)

        $isTripNameValid
            .assign(to: \.canUpdateTrip, on: self)
            .store(in: &cancellableSet)
    }

    func fetchTrip() async {
        self.isLoading = true
        let (trip, errorMessage) = await tripService.fetchTrip(withTripId: trip.id)
        guard let trip = trip else {
            self.isDeleted = true
            self.isLoading = false
            return
        }
        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.trip = trip
        self.isLoading = false
    }

    func updateTrip() async {
        self.isLoading = true
        let (hasUpdated, errorMessage) = await tripService.updateTrip(trip: trip)
        guard hasUpdated, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

    func deleteTrip() async {
        self.isLoading = true
        let (hasDeleted, errorMessage) = await tripService.deleteTrip(trip: trip)
        guard hasDeleted, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isDeleted = true
        self.isLoading = false
    }

    func inviteUser(email: String) async {
        self.isLoading = true

        // fetch user
        let (user, userErrorMessage) = await userService.getUser(with: "email", value: email)

        guard userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        guard let user = user else { // user not null
            print("Email is incorrect")
            self.isLoading = false
            return
        }

        let userId = user.id

        // fetch trip
        let (tripCopy, tripErrorMessage) = await tripService.fetchTrip(withTripId: trip.id)
        guard tripErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        guard var tripCopy = tripCopy else {
            self.isDeleted = true
            self.isLoading = false
            return
        }

        // update trip
        guard !tripCopy.attendeesUserIds.contains(userId) else { // user not in trip
            print("User already invited")
            self.isLoading = false
            return
        }

        tripCopy.attendeesUserIds.append(userId)

        let (hasUpdated, updateErrorMessage) = await tripService.updateTrip(trip: tripCopy)
        guard hasUpdated, updateErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        self.isLoading = false
    }

    func fetchAttendees() async {
        var fetchedAttendees: [User] = []

        for userId in trip.attendeesUserIds {
            let (user, userErrorMessage) = await userService.getUser(with: "id", value: userId)

            guard userErrorMessage.isEmpty else {
                self.isLoading = false
                self.hasError = true
                return
            }

            guard let user = user else { // user not null
                print("No user exists with id \(userId)")
                self.isLoading = false
                self.hasError = true
                return
            }

            fetchedAttendees.append(user)
        }

        self.attendees = fetchedAttendees
    }
}
