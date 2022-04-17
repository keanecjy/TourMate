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
            ForEach(viewModel.daysWithOverlapSummary, id: \.0.date) { day, summary in
                VStack(alignment: .leading) {
                    PlanDateView(date: day.date, timeZone: Calendar.current.timeZone)

                    if !summary.isEmpty {
                        Text("Take note: Some plans are overlapping!")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding([.vertical], 2.0)

                        ExpandableTextView(content: summary, allowedLineLimit: 0, font: .subheadline)
                    }

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
