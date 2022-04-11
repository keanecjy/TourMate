//
//  StartEndDatePicker.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct StartEndDatePicker: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    let lowerBoundDate: Date
    let upperBoundDate: Date

    var body: some View {
        DatePicker("Start Date",
                   selection: $startDate,
                   in: lowerBoundDate...upperBoundDate,
                   displayedComponents: [.date, .hourAndMinute])

        DatePicker("End Date",
                   selection: $endDate,
                   in: lowerBoundDate...upperBoundDate,
                   displayedComponents: [.date, .hourAndMinute])
    }
}

// struct StartEndDatePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        StartEndDatePicker()
//    }
// }
