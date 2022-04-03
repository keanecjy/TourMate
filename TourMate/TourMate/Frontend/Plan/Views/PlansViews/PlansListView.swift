//
//  PlansListView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansListView: View {
    let days: [Day]
    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime
    let onSelected: ((Plan) -> Void)?

    init(days: [Day],
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         onSelected: ((Plan) -> Void)? = nil) {
        self.days = days
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.onSelected = onSelected
    }

    var body: some View {
        VStack {
            ForEach(days, id: \.date) { day in
                VStack(alignment: .leading) {
                    PlanHeaderView(date: day.date, timeZone: Calendar.current.timeZone)

                    ForEach(day.plans, id: \.id) { plan in
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
