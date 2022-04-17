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
}
