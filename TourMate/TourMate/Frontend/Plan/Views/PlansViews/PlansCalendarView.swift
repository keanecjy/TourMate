//
//  PlansCalendarView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansCalendarView: View {

    @State private var selectedDate = Date()
    let plansByDate: PlansByDate
    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime
    let onSelected: ((Plan) -> Void)?

    init(plansByDate: PlansByDate,
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         onSelected: ((Plan) -> Void)? = nil) {
        self.plansByDate = plansByDate
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.onSelected = onSelected
    }

    var sortedDates: [Date] {
        plansByDate.keys.sorted(by: <)
    }

    func getPlans(for date: Date) -> [Plan] {
        return plansByDate[date] ?? []
    }

    var body: some View {
        LazyVStack {
            HStack {
                Picker("Date", selection: $selectedDate) {
                    ForEach(sortedDates, id: \.self) { date in
                        PlanHeaderView(date: date, timeZone: Calendar.current.timeZone)
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
        .task {
            selectedDate = sortedDates.first ?? Date()
        }
    }
}
