//
//  PlansListView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansListView: View {
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
        plansByDate[date] ?? []
    }

    var body: some View {
        LazyVStack {
            ForEach(sortedDates, id: \.self) { date in
                VStack(alignment: .leading) {
                    PlanHeaderView(date: date, timeZone: Calendar.current.timeZone)

                    ForEach(getPlans(for: date), id: \.id) { plan in
                        PlanCardView(viewModel: PlanViewModel(plan: plan,
                                                              lowerBoundDate: lowerBoundDate,
                                                              upperBoundDate: upperBoundDate)
                        )
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
    }
}
