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

    // TripFormViewModel
    @Published var tripName: String = ""
    var tripNamePublisher: Published<String>.Publisher { $tripName }

    @Published var tripStartDate = Date()
    var tripStartDatePublisher: Published<Date>.Publisher { $tripStartDate }

    @Published var tripEndDate = Date()
    var tripEndDatePublisher: Published<Date>.Publisher { $tripEndDate }

    @Published var tripImageURL: String = ""
    var tripImageURLPublisher: Published<String>.Publisher { $tripImageURL }

    @Published var fromStartDate = Date()...
    var fromStartDatePublisher: Published<PartialRangeFrom<Date>>.Publisher { $fromStartDate }

    let tripService: TripService
    let userService: UserService

    private var cancellableSet: Set<AnyCancellable> = []

    init(tripService: TripService = FirebaseTripService(),
         userService: UserService = FirebaseUserService()) {
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
            .assign(to: \.canAddTrip, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($tripStartDate, $tripEndDate)
            .map({ max($0, $1) })
            .assign(to: \.tripEndDate, on: self)
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

        let creatorUserId = user.id
        let uuid = UUID().uuidString
        let name = tripName
        let imageUrl = tripImageURL
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: tripStartDate)
        let end = calendar.date(bySettingHour: 23,
                                minute: 59,
                                second: 59,
                                of: tripEndDate) ?? tripEndDate

        let startDateTime = DateTime(date: start, timeZone: TimeZone.current)
        let endDateTime = DateTime(date: end, timeZone: TimeZone.current)

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
