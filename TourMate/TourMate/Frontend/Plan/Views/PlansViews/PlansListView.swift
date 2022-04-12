//
//  PlansListView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansListView: View {

    @ObservedObject var viewModel: PlansViewModel

    let onSelected: ((Plan) -> Void)?

    private let viewModelFactory = ViewModelFactory()

    init(viewModel: PlansViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelected = onSelected
    }

    var body: some View {
        VStack {
            ForEach(viewModel.days, id: \.date) { day in
                VStack(alignment: .leading) {
                    PlanDateView(date: day.date, timeZone: Calendar.current.timeZone)

                    ForEach(day.plans, id: \.id) { plan in
                        PlanCardView(plansViewModel: viewModel, plan: plan, date: day.date)
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
