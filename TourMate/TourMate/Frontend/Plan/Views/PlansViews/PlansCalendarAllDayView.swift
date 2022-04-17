//
//  PlansCalendarAllDayView.swift
//  TourMate
//
//  Created by Rayner Lim on 17/4/22.
//

import SwiftUI

struct PlansCalendarAllDayView: View {
    @ObservedObject var viewModel: PlansViewModel

    let date: Date
    let plans: [Plan]
    let onSelected: ((Plan) -> Void)?

    private let viewModelFactory = ViewModelFactory()

    init(viewModel: PlansViewModel,
         date: Date,
         plans: [Plan] = [],
         onSelected: ((Plan) -> Void)? = nil) {

        self.viewModel = viewModel
        self.date = date
        self.plans = plans
        self.onSelected = onSelected
    }

    var body: some View {
        HStack(alignment: .center) {
            Text("All Day")
                .font(.caption)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(plans, id: \.id) { plan in
                        PlanBoxView(plansViewModel: viewModel, plan: plan, date: date)
                        .onTapGesture {
                            if let onSelected = onSelected {
                                onSelected(plan)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.primary.opacity(0.25))
                        )
                    }
                }
            }
        }
        .padding()
    }
}
