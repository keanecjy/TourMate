//
//  DateTime.swift
//  TourMate
//
//  Created by Tan Rui Quan on 24/3/22.
//

import Foundation

struct DateTime: Equatable, Comparable, CustomStringConvertible {
    var date = Date()
    var timeZone = TimeZone.current

    var description: String {
        DateUtil.defaultDateDisplay(date: date, at: timeZone)
    }

    var timezoneEpochOffset: Double {
        let timezoneOffset = timeZone.secondsFromGMT()
        let epochDate = date.timeIntervalSince1970
        return epochDate + Double(timezoneOffset)
    }

    func revertEpochOffset(offset: Double) -> Double {
        let timezoneOffset = Double(timeZone.secondsFromGMT())
        return offset - timezoneOffset
    }

    // compare absolute time differences from 0-GMT
    // https://www.agnosticdev.com/content/how-convert-swift-dates-timezone
    static func < (lhs: DateTime, rhs: DateTime) -> Bool {
        let lhsTimezoneOffsetDate = Date(timeIntervalSince1970: lhs.timezoneEpochOffset)
        let rhsTimezoneOffsetDate = Date(timeIntervalSince1970: rhs.timezoneEpochOffset)

        return lhsTimezoneOffsetDate < rhsTimezoneOffsetDate
    }
}
