//
//  TripFormViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 31/3/22.
//

import Foundation
import Combine

@MainActor
class TripFormViewModel: ObservableObject {
    @Published var isTripNameValid: Bool
    @Published var canSubmitTrip: Bool

    @Published var tripName: String
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var tripImageURL: String
    @Published var fromStartDate: PartialRangeFrom<Date>

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        self.isTripNameValid = false
        self.canSubmitTrip = false

        self.tripName = ""
        self.tripStartDate = Date()
        self.tripEndDate = Date()
        self.tripImageURL = ""
        self.fromStartDate = Date()...

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
            .assign(to: \.canSubmitTrip, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($tripStartDate, $tripEndDate)
            .map({ max($0, $1) })
            .assign(to: \.tripEndDate, on: self)
            .store(in: &cancellableSet)
    }

    init(trip: Trip) {
        self.isTripNameValid = !trip.name.isEmpty
        self.canSubmitTrip = !trip.name.isEmpty

        self.tripName = trip.name
        self.tripStartDate = trip.startDateTime.date
        self.tripEndDate = trip.endDateTime.date
        self.tripImageURL = trip.imageUrl ?? ""
        self.fromStartDate = trip.startDateTime.date...

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
            .assign(to: \.canSubmitTrip, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($tripStartDate, $tripEndDate)
            .map({ max($0, $1) })
            .assign(to: \.tripEndDate, on: self)
            .store(in: &cancellableSet)
    }

    func generateDateTimes(startTimeZone: TimeZone = TimeZone.current, endTimeZone: TimeZone = TimeZone.current) -> (DateTime, DateTime) {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: tripStartDate)
        let end = calendar.date(bySettingHour: 23,
                                minute: 59,
                                second: 59,
                                of: tripEndDate) ?? tripEndDate

        let startDateTime = DateTime(date: start, timeZone: startTimeZone)
        let endDateTime = DateTime(date: end, timeZone: endTimeZone)

        return (startDateTime, endDateTime)
    }
}
