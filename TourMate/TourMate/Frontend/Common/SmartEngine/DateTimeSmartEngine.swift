//
//  DateTimeSmartEngine.swift
//  TourMate
//
//  Created by Terence Ho on 17/4/22.
//

import Foundation

struct DateTimeSmartEngine {
    // take in a list of DateTimeRangeOwner and compute overlaps
    // Suggest changes for overlaps

    func computeOverlap(dateTimeRangeOwners: [DateTimeRangeOwner]) -> [(DateTimeRangeOwner, DateTimeRangeOwner)] {
        let sortedDateTimeRangeOwners = dateTimeRangeOwners.sorted(by: { $0.startDateTime < $1.startDateTime })

        var overlappingRanges: [(DateTimeRangeOwner, DateTimeRangeOwner)] = []

        for i in 0 ..< (sortedDateTimeRangeOwners.count - 1) {
            for j in (i + 1) ..< sortedDateTimeRangeOwners.count {
                // overlap
                if sortedDateTimeRangeOwners[j].startDateTime < sortedDateTimeRangeOwners[i].endDateTime {
                    overlappingRanges.append((sortedDateTimeRangeOwners[i], sortedDateTimeRangeOwners[j]))
                } else {
                    break
                }
            }
        }

        return overlappingRanges
    }

    // https://stackoverflow.com/questions/8205662/algorithm-to-shift-overlapping-intervals-until-no-overlap-is-left
    func suggestNewTimings(dateTimeRangeOwners: [DateTimeRangeOwner]) -> [DateTimeRangeOwner] {
        guard !dateTimeRangeOwners.isEmpty else {
            return []
        }

        var newTimings: [DateTimeRangeOwner] = []
        let sortedDateTimeRangeOwners = dateTimeRangeOwners.sorted(by: { $0.startDateTime < $1.startDateTime })

        let overallTimeSum = sortedDateTimeRangeOwners.map { owner in
            owner.startDateTime.timezoneEpochOffset + owner.endDateTime.timezoneEpochOffset
        }
        .reduce(into: 0) { acc, curr in
            acc += curr
        }

        let totalTimeLength = sortedDateTimeRangeOwners.map { owner in
            owner.endDateTime.timezoneEpochOffset - owner.startDateTime.timezoneEpochOffset
        }
        .reduce(into: 0) { acc, curr in
            acc += curr
        }

        let overallAverage = overallTimeSum / (Double(sortedDateTimeRangeOwners.count) * 2.0)
        let average = totalTimeLength / 2.0

        let newMinTime = overallAverage - average
        let initialMinTime = sortedDateTimeRangeOwners.first?.startDateTime.timezoneEpochOffset ?? newMinTime
        var current = initialMinTime

        for owner in sortedDateTimeRangeOwners {
            var newOwner = owner
            let difference = newOwner.endDateTime.timezoneEpochOffset - newOwner.startDateTime.timezoneEpochOffset

            let newStart = current
            let newEnd = current + difference

            current = newEnd

            let newStartTimezoned = newOwner.startDateTime.revertEpochOffset(offset: newStart)
            let newEndTimezoned = newOwner.endDateTime.revertEpochOffset(offset: newEnd)

            newOwner.startDateTime.date = Date(timeIntervalSince1970: newStartTimezoned)
            newOwner.endDateTime.date = Date(timeIntervalSince1970: newEndTimezoned)

            newTimings.append(newOwner)
        }

        return newTimings
    }
}
