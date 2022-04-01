//
//  PlansListView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansListView: View {
    @StateObject var plansViewModel: PlansViewModel
    var tripViewModel: TripViewModel

    let onSelected: ((Plan) -> Void)?

    init(tripViewModel: TripViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self._plansViewModel = StateObject(wrappedValue: PlansViewModel())
        self.tripViewModel = tripViewModel
        self.onSelected = onSelected
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

    var body: some View {
        LazyVStack {
            ForEach(days, id: \.date) { day in
                VStack(alignment: .leading) {
                    PlanHeaderView(date: day.date, timeZone: Calendar.current.timeZone)

                    ForEach(day.plans, id: \.id) { plan in
                        PlanCardView(viewModel: PlanViewModel(plan: plan, trip: tripViewModel.trip))
                            .onTapGesture(perform: {
                                if let onSelected = onSelected {
                                    onSelected(plan)
                                }
                            })
                            .buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: .infinity, maxHeight: 100.0)
                            .background(RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.primary.opacity(0.1)))
                    }
                }
                .padding()
            }
        }
        .task {
            await plansViewModel.fetchPlansAndListen(withTripId: tripViewModel.trip.id)
            print("[PlansListView] Fetched plans: \(plansViewModel.plans)")
        }
        .onDisappear(perform: { () in plansViewModel.detachListener() })
    }
}

// struct PlansListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlansListView(id: 0).environmentObject(MockModel())
//    }
// }
