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
class AddTripViewModel: ObservableObject, TripFormViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    @Published var isTripNameValid = false
    @Published var canAddTrip = false

    @Published var trip: Trip
    var tripPublisher: Published<Trip>.Publisher { $trip }

    @Published var fromStartDate = Date()...
    var fromStartDatePublisher: Published<PartialRangeFrom<Date>>.Publisher { $fromStartDate }

    let tripService: TripService
    let userService: UserService

    private var cancellableSet: Set<AnyCancellable> = []

    init(tripService: TripService = FirebaseTripService(),
         userService: UserService = FirebaseUserService()) {
        self.tripService = tripService
        self.userService = userService

        self.trip = Trip(id: UUID().uuidString, name: "",
                         startDateTime: DateTime(), endDateTime: DateTime(),
                         imageUrl: "", attendeesUserIds: [], invitedUserIds: [],
                         creationDate: Date(), modificationDate: Date())

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
            .assign(to: \.canAddTrip, on: self)
            .store(in: &cancellableSet)

        // ???
//        Publishers
//            .CombineLatest($startDate, $endDate)
//            .map({ max($0, $1) })
//            .assign(to: \.endDate, on: self)
//            .store(in: &cancellableSet)
    }

    func addTrip() async {
        self.isLoading = true
        let (user, userErrorMessage) = await userService.getCurrentUser()
        guard let user = user, userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        let creatorUserId = user.id
        let uuid = trip.id
        let name = trip.name
        let imageUrl = trip.imageUrl
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: trip.startDateTime.date)
        let end = calendar.date(bySettingHour: 23,
                                minute: 59,
                                second: 59,
                                of: trip.endDateTime.date) ?? trip.endDateTime.date

        let startDateTime = DateTime(date: start, timeZone: trip.startDateTime.timeZone)
        let endDateTime = DateTime(date: end, timeZone: trip.endDateTime.timeZone)

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
