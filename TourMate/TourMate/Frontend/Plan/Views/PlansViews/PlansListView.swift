//
//  PlansListView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansListView: View {
    @StateObject var viewModel: PlansViewModel

    let onSelected: ((Plan) -> Void)?

    init(viewModel: PlansViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onSelected = onSelected
    }

    var body: some View {
        LazyVStack {
            ForEach(viewModel.days, id: \.date) { day in

                VStack(alignment: .leading) {
                    PlanHeaderView(date: day.date, timeZone: Calendar.current.timeZone)

                    ForEach(day.plans, id: \.id) { plan in
                        PlanCardView(viewModel: ViewModelFactory.getPlanViewModel(plan: plan, plansViewModel: viewModel))
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
            await viewModel.fetchPlansAndListen()
            print("[PlansListView] Fetched plans: \(viewModel.plans)")
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}

// struct PlansListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlansListView(id: 0).environmentObject(MockModel())
//    }
// }
