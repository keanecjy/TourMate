//
//  PlansMapView.swift
//  TourMate
//
//  Created by Rayner Lim on 11/4/22.
//

import SwiftUI

struct IdentifiablePlan: Identifiable, Equatable {
    static func == (lhs: IdentifiablePlan, rhs: IdentifiablePlan) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let plan: Plan
}

struct PlansMapView: View {

    @State private var selectedDate = Date()
    @State private var showProposedPlans = false
    @ObservedObject var viewModel: PlansViewModel
    let onSelected: ((Plan) -> Void)?

    init(viewModel: PlansViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelected = onSelected
    }

    func getIdentifiablePlans(for date: Date) -> [IdentifiablePlan] {
        let plans = viewModel.days.first { $0.date == date }?.plans ?? []
        return Array(zip(plans.indices, plans)).map { index, plan in
            IdentifiablePlan(id: index, plan: plan)
        }
    }

    var body: some View {
        PlansMapDayView(viewModel: viewModel,
                        date: selectedDate,
                        idPlans: getIdentifiablePlans(for: selectedDate),
                        onSelected: onSelected)
        .onAppear {
            selectedDate = viewModel.days.first?.date ?? Date()
        }
        .navigationTitle("Map View")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Date", selection: $selectedDate) {
                    ForEach(viewModel.days, id: \.date) { day in
                        PlanDateView(date: day.date, timeZone: Calendar.current.timeZone)
                    }
                }
                .pickerStyle(.menu)
                .padding([.horizontal])
                .background(
                    Capsule()
                        .strokeBorder(Color(.link), lineWidth: 1)
                        .background(Capsule()
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.primary.opacity(0.2), radius: 2)
                                    )
                )
            }
            ToolbarItem(placement: .primaryAction) {
                Toggle(showProposedPlans ? "Hide Proposed Plans" : "Show Proposed Plans", isOn: $showProposedPlans)
            }
        }
        .ignoresSafeArea()
    }
}
