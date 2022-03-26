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
class AddTripViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    @Published var tripName = ""
    @Published var startDate = Date()
    @Published var startTimeZone = TimeZone.current
    @Published var endDate = Date()
    @Published var endTimeZone = TimeZone.current
    @Published var imageUrl = ""
    @Published var isTripNameValid = false
    @Published var fromStartDate = Date()...
    @Published var canAddTrip = false

    let tripService: TripService
    let userService: UserService

    private var cancellableSet: Set<AnyCancellable> = []

    init(tripService: TripService = FirebaseTripService(),
         userService: UserService = FirebaseUserService()) {
        self.tripService = tripService
        self.userService = userService

        $tripName
            .map({ !$0.isEmpty })
            .assign(to: \.isTripNameValid, on: self)
            .store(in: &cancellableSet)

        $startDate
            .map({ $0... })
            .assign(to: \.fromStartDate, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($startDate, $endDate)
            .map({ max($0, $1) })
            .assign(to: \.endDate, on: self)
            .store(in: &cancellableSet)

        $isTripNameValid
            .assign(to: \.canAddTrip, on: self)
            .store(in: &cancellableSet)
    }

    func addTrip() async {
        self.isLoading = true
        let (user, userErrorMessage) = await userService.getUser()
        guard let user = user, userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        let uuid = UUID().uuidString
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: startDate)
        let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
        let startDateTime = DateTime(date: start, timeZone: startTimeZone)
        let endDateTime = DateTime(date: end, timeZone: endTimeZone)
        let trip = Trip(id: uuid, name: tripName,
                        startDateTime: startDateTime,
                        endDateTime: endDateTime,
                        imageUrl: imageUrl,
                        creatorUserId: user.id)
        let (hasAddedTrip, tripErrorMessage) = await tripService.addTrip(trip: trip)
        guard hasAddedTrip == true, tripErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

}
