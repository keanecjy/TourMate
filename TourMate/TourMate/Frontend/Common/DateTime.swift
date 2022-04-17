//
//  DateTime.swift
//  TourMate
//
//  Created by Tan Rui Quan on 24/3/22.
//

import Foundation

struct DateTime: Equatable, CustomStringConvertible {
    var date = Date()
    var timeZone = TimeZone.current

    var description: String {
        DateUtil.defaultDateDisplay(date: date, at: timeZone)
    }
}
