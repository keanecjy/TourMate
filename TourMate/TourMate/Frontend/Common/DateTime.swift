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

    static func < (lhs: DateTime, rhs: DateTime) -> Bool {
        generateTimezoneOffsetDate(dateTime: lhs) < generateTimezoneOffsetDate(dateTime: rhs)
    }

    // compare absolute time differences from 0-GMT
    // https://www.agnosticdev.com/content/how-convert-swift-dates-timezone
    private static func generateTimezoneOffsetDate(dateTime: DateTime) -> Date {
        let timezoneOffset = dateTime.timeZone.secondsFromGMT()
        let epochDate = dateTime.date.timeIntervalSince1970
        let timezoneEpochOffset = epochDate + Double(timezoneOffset)
        let timezoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timezoneOffsetDate
    }
}
