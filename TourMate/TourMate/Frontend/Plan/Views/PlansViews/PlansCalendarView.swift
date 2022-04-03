//
//  PlansCalendarView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansCalendarView: View {

    @State private var selectedDate = Date()
    let days: [Day]
    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime
    let onSelected: ((Plan) -> Void)?

    init(days: [Day],
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         onSelected: ((Plan) -> Void)? = nil) {
        self.days = days
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.onSelected = onSelected
    }

    func getPlans(for date: Date) -> [Plan] {
        /*
        days.first { day in
            day.date == date
        }?.plans ?? []
         */
        days.first?.plans ?? []
    }

    var body: some View {
        LazyVStack {
            HStack {
                Picker("Date", selection: $selectedDate) {
                    ForEach(days, id: \.date) { day in
                        PlanHeaderView(date: day.date, timeZone: Calendar.current.timeZone)
                    }
                }
                .pickerStyle(.menu)
                .padding([.horizontal])
                .background(
                    Capsule().fill(Color.primary.opacity(0.25))
                )
                Spacer()
            }
            .padding()

            PlansDayView(plans: getPlans(for: selectedDate),
                         lowerBoundDate: lowerBoundDate,
                         upperBoundDate: upperBoundDate,
                         onSelected: onSelected)
            .padding()
        }
    }
}
