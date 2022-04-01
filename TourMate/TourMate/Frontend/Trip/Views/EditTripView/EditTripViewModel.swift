//
//  EditTripViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 1/4/22.
//

import Foundation
import Combine

@MainActor
class EditTripViewModel: TripFormViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    @Published var isTripNameValid = true
    @Published var canUpdateTrip = true

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
