//
//  PlansCalendarView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansCalendarView: View {
    @StateObject var plansViewModel: PlansViewModel
    @ObservedObject var tripViewModel: TripViewModel

    @State private var selectedDate = Date()

    init(tripId: String, tripViewModel: TripViewModel) {
        self._plansViewModel = StateObject(wrappedValue: PlansViewModel(tripId: tripId))
        self.tripViewModel = tripViewModel
    }

    typealias Day = (date: Date, plans: [Plan])
    var days: [Day] {
        let sortedPlans = plansViewModel.plans.sorted { plan1, plan2 in
            plan1.startDateTime.date < plan2.startDateTime.date
        }
        let plansByDay: [Date: [Plan]] = sortedPlans.reduce(into: [:]) { acc, cur in
            let components = Calendar
                .current
                .dateComponents(in: cur.startDateTime.timeZone, from: cur.startDateTime.date)
            let dateComponents = DateComponents(year: components.year,
                                                month: components.month,
                                                day: components.day)
            let date = Calendar.current.date(from: dateComponents)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        return plansByDay.sorted(by: { $0.key < $1.key }).map { day in
            (date: day.key, plans: day.value)
        }
    }

    func getPlans(for date: Date) -> [Plan] {
        days.filter { day in
            day.date == date
        }.first?.plans ?? []
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

            PlansDayView(tripViewModel: tripViewModel, plans: getPlans(for: selectedDate))
            .padding()
        }
        .task {
            await plansViewModel.fetchPlans()
            print("[PlansListView] Fetched plans: \(plansViewModel.plans)")
            if !days.isEmpty {
                self.selectedDate = days[0].date
            }
        }
    }
}

// struct PlansListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlansListView(id: 0).environmentObject(MockModel())
//    }
// }
