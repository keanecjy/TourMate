//
//  PlansView.swift
//  TourMate
//
//  Created by Rayner Lim on 2/4/22.
//
import SwiftUI

typealias Day = (date: Date, plans: [Plan])

enum PlansViewMode: String, CaseIterable {
    case list, calendar
}

struct PlansView: View {
    @StateObject var plansViewModel: PlansViewModel
    @ObservedObject var tripViewModel: TripViewModel
    @State private var selectedViewMode: PlansViewMode = .list

    let onSelected: ((Plan) -> Void)?

    init(tripViewModel: TripViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self._plansViewModel = StateObject(wrappedValue: PlansViewModel())
        self.tripViewModel = tripViewModel
        self.onSelected = onSelected
    }

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

    var body: some View {
        VStack {
            Picker("View Mode", selection: $selectedViewMode) {
                Label("Itinerary", systemImage: "list.bullet.rectangle").tag(PlansViewMode.list)
                Label("Calendar", systemImage: "calendar.day.timeline.left").tag(PlansViewMode.calendar)
            }
            .pickerStyle(.segmented)
            .padding()
            Group {
                if selectedViewMode == .list {
                    PlansListView(days: days,
                                  lowerBoundDate: tripViewModel.trip.startDateTime,
                                  upperBoundDate: tripViewModel.trip.endDateTime,
                                  onSelected: onSelected)
                } else if selectedViewMode == .calendar {
                    PlansCalendarView(days: days,
                                      lowerBoundDate: tripViewModel.trip.startDateTime,
                                      upperBoundDate: tripViewModel.trip.endDateTime,
                                      onSelected: onSelected)
                }
            }
        }
        .task {
            await plansViewModel.fetchPlansAndListen(withTripId: tripViewModel.trip.id)
            print("[PlansListView] Fetched plans: \(plansViewModel.plans)")
        }
        .onDisappear(perform: { () in plansViewModel.detachListener() })
    }
}
