//
//  TripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation
import Combine

@MainActor
class TripViewModel: ObservableObject, TripFormViewModel {

    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    @Published var isTripNameValid = true
    @Published var canUpdateTrip = true

    @Published var attendees: [User] = []
    @Published var trip: Trip

    // TripFormViewModel
    @Published var tripName: String
    var tripNamePublisher: Published<String>.Publisher { $tripName }

    @Published var tripStartDate: Date
    var tripStartDatePublisher: Published<Date>.Publisher { $tripStartDate }

    @Published var tripEndDate: Date
    var tripEndDatePublisher: Published<Date>.Publisher { $tripEndDate }

    @Published var tripImageURL: String
    var tripImageURLPublisher: Published<String>.Publisher { $tripImageURL }

    @Published var fromStartDate: PartialRangeFrom<Date>
    var fromStartDatePublisher: Published<PartialRangeFrom<Date>>.Publisher { $fromStartDate }

    private var tripService: TripService
    private let userService: UserService

    private var cancellableSet: Set<AnyCancellable> = []

    init(trip: Trip,
         tripService: TripService = FirebaseTripService(),
         userService: UserService = FirebaseUserService()) {

        self.trip = trip

        self.tripName = trip.name
        self.tripStartDate = trip.startDateTime.date
        self.tripEndDate = trip.endDateTime.date
        self.tripImageURL = trip.imageUrl ?? ""
        self.fromStartDate = trip.startDateTime.date...

        self.tripService = tripService
        self.userService = userService

        // Constraints on Trip
        $tripName
            .map({ !$0.isEmpty })
            .assign(to: \.isTripNameValid, on: self)
            .store(in: &cancellableSet)

        $tripStartDate
            .map({ $0... })
            .assign(to: \.fromStartDate, on: self)
            .store(in: &cancellableSet)

        $isTripNameValid
            .assign(to: \.canUpdateTrip, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($tripStartDate, $tripEndDate)
            .map({ max($0, $1) })
            .assign(to: \.tripEndDate, on: self)
            .store(in: &cancellableSet)
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

    // As of now, only used for EditTripView
    // Save the information that are edited
    func updateTrip() async {
        self.isLoading = true

        let startDateTime = DateTime(date: tripStartDate, timeZone: trip.startDateTime.timeZone)
        let endDateTime = DateTime(date: tripEndDate, timeZone: trip.endDateTime.timeZone)
        let updatedTrip = Trip(id: trip.id,
                               name: tripName,
                               startDateTime: startDateTime,
                               endDateTime: endDateTime,
                               imageUrl: tripImageURL,
                               attendeesUserIds: trip.attendeesUserIds,
                               invitedUserIds: trip.invitedUserIds,
                               creationDate: trip.creationDate,
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

    func inviteUser(email: String) async {
        self.isLoading = true

        // fetch user
        let (user, userErrorMessage) = await userService.getUser(with: "email", value: email)

        guard userErrorMessage.isEmpty else {
            handleError()
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
            handleError()
            return
        }

        guard var tripCopy = tripCopy else {
            handleDeletion()
            return
        }

        // update trip
        guard !tripCopy.attendeesUserIds.contains(userId) else { // user not in trip
            print("[TripViewModel] User already invited")
            self.isLoading = false
            return
        }

        tripCopy.attendeesUserIds.append(userId)

        let (hasUpdated, updateErrorMessage) = await tripService.updateTrip(trip: tripCopy)
        guard hasUpdated, updateErrorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }

    private func fetchAttendees() async {
        var fetchedAttendees: [User] = []

        for userId in trip.attendeesUserIds {
            let (user, userErrorMessage) = await userService.getUser(with: "id", value: userId)

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
