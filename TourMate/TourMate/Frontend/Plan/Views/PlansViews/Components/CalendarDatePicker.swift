//
//  CalendarDatePicker.swift
//  TourMate
//
//  Created by Keane Chan on 17/4/22.
//

import SwiftUI

struct CalendarDatePicker: View {
    @Binding var selectedDate: Date

    let days: [Day]

    var body: some View {
        Picker("Date", selection: $selectedDate) {
            ForEach(days, id: \.date) { day in
                PlanDateView(date: day.date, timeZone: Calendar.current.timeZone)
            }
        }
        .pickerStyle(.menu)
        .padding([.horizontal])
        .background(
            Capsule().fill(Color.primary.opacity(0.2))
        )

    }
}
