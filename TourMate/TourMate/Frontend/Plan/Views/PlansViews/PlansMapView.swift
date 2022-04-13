//
//  PlansMapView.swift
//  TourMate
//
//  Created by Rayner Lim on 11/4/22.
//

import SwiftUI

struct PlansMapView: View {

    @State private var selectedDate = Date()
    @ObservedObject var viewModel: PlansViewModel
    let onSelected: ((Plan) -> Void)?

    init(viewModel: PlansViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelected = onSelected
    }

    func getPlans(for date: Date) -> [(Int, Plan)] {
        let plans = viewModel.days.first { $0.date == date }?.plans ?? []
        return Array(zip(plans.indices, plans))
    }

    var body: some View {
        LazyVStack {
            HStack {
                Picker("Date", selection: $selectedDate) {
                    ForEach(viewModel.days, id: \.date) { day in
                        PlanDateView(date: day.date, timeZone: Calendar.current.timeZone)
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
            PlansMapDayView(viewModel: viewModel,
                            date: selectedDate,
                            plans: getPlans(for: selectedDate),
                            onSelected: onSelected)
        }
        .task {
            selectedDate = viewModel.days.first?.date ?? Date()
        }
    }
}
