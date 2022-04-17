//
//  PlansCalendarView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansNewCalendarView: View {

    @State private var selectedDate = Date()
    @State private var showProposedPlans = false
    @ObservedObject var viewModel: PlansViewModel
    let onSelected: ((Plan) -> Void)?

    init(viewModel: PlansViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelected = onSelected
    }

    func getPlans(for date: Date, includingProposedPlans: Bool = false) -> [Plan] {
        let plans = viewModel.days.first { $0.date == date }?.plans ?? []
        if includingProposedPlans {
            return plans
        }
        return plans.filter { $0.status == .confirmed }
    }

    func getAllDayPlans(for date: Date, includingProposedPlans: Bool = false) -> [Plan] {
        let plans = getPlans(for: date, includingProposedPlans: includingProposedPlans)
        let dayStartDate = date
        let dayEndDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        return plans.filter { plan in
            (plan.startDateTime.date <= dayStartDate && plan.endDateTime.date >= dayEndDate) ||
            plan is Accommodation
        }
    }

    func getNonAllDayPlans(for date: Date, includingProposedPlans: Bool = false) -> [Plan] {
        let plans = getPlans(for: date, includingProposedPlans: includingProposedPlans)
        let dayStartDate = date
        let dayEndDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        return plans.filter { plan in
            !((plan.startDateTime.date <= dayStartDate && plan.endDateTime.date >= dayEndDate) || plan is Accommodation)
        }
    }

    var body: some View {
        VStack {
            PlansCalendarDayView(viewModel: viewModel,
                                 date: selectedDate,
                                 plans: getNonAllDayPlans(for: selectedDate, includingProposedPlans: showProposedPlans),
                                 onSelected: onSelected)
            Divider()
            PlansCalendarAllDayView(viewModel: viewModel,
                                    date: selectedDate,
                                    plans: getAllDayPlans(for: selectedDate, includingProposedPlans: showProposedPlans),
                                    onSelected: onSelected)
        }
        .onAppear {
            selectedDate = viewModel.days.first?.date ?? Date()
        }
        .navigationTitle("Calendar View")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Date", selection: $selectedDate) {
                    ForEach(viewModel.days, id: \.date) { day in
                        PlanDateView(date: day.date, timeZone: Calendar.current.timeZone)
                    }
                }
                .pickerStyle(.menu)
            }
            ToolbarItem(placement: .primaryAction) {
                Toggle(isOn: $showProposedPlans) {
                    Text("Show Proposed Plans")
                        .font(.subheadline)
                        .foregroundColor(Color(.link))
                        .padding([.leading])
                }
                .toggleStyle(.switch)
            }
        }
    }
}
