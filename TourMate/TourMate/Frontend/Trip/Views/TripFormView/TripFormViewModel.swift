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
    var tripName: String { get set }
    var tripNamePublisher: Published<String>.Publisher { get }

    var tripStartDate: Date { get set }
    var tripStartDatePublisher: Published<Date>.Publisher { get }

    var tripEndDate: Date { get set }
    var tripEndDatePublisher: Published<Date>.Publisher { get }

    var tripImageURL: String { get set }
    var tripImageURLPublisher: Published<String>.Publisher { get }

    var fromStartDate: PartialRangeFrom<Date> { get set }
    var fromStartDatePublisher: Published<PartialRangeFrom<Date>>.Publisher { get }
}
