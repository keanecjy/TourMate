//
//  TripFormViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 31/3/22.
//

import Foundation

// https://swiftsenpai.com/swift/define-protocol-with-published-property-wrapper/
@MainActor
protocol TripFormViewModel: ObservableObject {
    var trip: Trip { get set }
    var tripPublisher: Published<Trip>.Publisher { get }

    var fromStartDate: PartialRangeFrom<Date> { get set }
    var fromStartDatePublisher: Published<PartialRangeFrom<Date>>.Publisher { get }
}
