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

    var body: some View {
        LazyVStack {
            ForEach(plansViewModel.days, id: \.date) { day in

                VStack(alignment: .leading) {
                    PlanHeaderView(date: day.date, timeZone: Calendar.current.timeZone)

                    ForEach(day.plans, id: \.id) { plan in
                        PlanCardView(viewModel: PlanViewModel(plan: plan,
                                                              lowerBoundDate: tripViewModel.trip.startDateTime,
                                                              upperBoundDate: tripViewModel.trip.endDateTime))
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
