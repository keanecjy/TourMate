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
    let startDateHeader: String
    let endDateHeader: String
    
    var body: some View {
        Section("Date & Time") {
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
}

// struct StartEndDatePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        StartEndDatePicker()
//    }
// }
