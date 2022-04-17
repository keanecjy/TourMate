//
//  DateTimeRangeOwner.swift
//  TourMate
//
//  Created by Terence Ho on 17/4/22.
//

import Foundation

protocol DateTimeRangeOwner {
    var startDateTime: DateTime { get set }
    var endDateTime: DateTime { get set }
}
