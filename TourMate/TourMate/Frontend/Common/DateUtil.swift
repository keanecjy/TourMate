//
//  DateUtil.swift
//  TourMate
//
//  Created by Keane Chan on 7/4/22.
//

import Foundation

struct DateUtil {
    static func shortDurationDesc(from startDateTime: DateTime, to endDateTime: DateTime) -> String {
        var description = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = startDateTime.timeZone
        description += dateFormatter.string(from: startDateTime.date)

        description += " - "

        dateFormatter.timeZone = endDateTime.timeZone
        description += dateFormatter.string(from: endDateTime.date)

        return description
    }
}
