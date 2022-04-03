//
//  PlansView.swift
//  TourMate
//
//  Created by Rayner Lim on 2/4/22.
//
import SwiftUI

typealias PlansByDate = [Date: [Plan]]

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

    var plansByDate: PlansByDate {
        let plans = plansViewModel.plans

        var res = PlansByDate()

        for plan in plans {
            let components = Calendar
                .current
                .dateComponents(in: plan.startDateTime.timeZone, from: plan.startDateTime.date)
            let dateComponents = DateComponents(year: components.year,
                                                month: components.month,
                                                day: components.day)
            let date = Calendar.current.date(from: dateComponents)!

            if res[date] == nil {
                res[date] = []
            }
            res[date]?.append(plan)
        }

        for (date, _) in res {
            res[date]?.sort(by: { $0.startDateTime.date < $1.startDateTime.date })
        }

        return res
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
                    PlansListView(plansByDate: plansByDate,
                                  lowerBoundDate: tripViewModel.trip.startDateTime,
                                  upperBoundDate: tripViewModel.trip.endDateTime,
                                  onSelected: onSelected)
                } else if selectedViewMode == .calendar {
                    PlansCalendarView(plansByDate: plansByDate,
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
