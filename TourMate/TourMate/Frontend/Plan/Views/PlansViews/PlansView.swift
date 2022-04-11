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
    @State private var selectedViewMode: PlansViewMode = .list

    let onSelected: ((Plan) -> Void)?

    init(plansViewModel: PlansViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self._plansViewModel = StateObject(wrappedValue: plansViewModel)
        self.onSelected = onSelected
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
                    PlansListView(viewModel: plansViewModel, onSelected: onSelected)
                } else if selectedViewMode == .calendar {
                    PlansCalendarView(viewModel: plansViewModel, onSelected: onSelected)
                }
            }
        }
        .task {
            await plansViewModel.fetchPlansAndListen()
            print("[PlansListView] Fetched plans: \(plansViewModel.plans)")
        }
        .onDisappear {
            plansViewModel.detachDelegates()
            plansViewModel.detachListener()
        }
    }
}
