//
//  PlansCalendarView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansCalendarView: View {
    @ObservedObject var viewModel: PlansViewModel

    @State private var selectedDate = Date()

    let onSelected: ((Plan) -> Void)?

    init(viewModel: PlansViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelected = onSelected
    }

    var body: some View {
        LazyVStack {
            HStack {
                CalendarDatePicker(selectedDate: $selectedDate, days: viewModel.days)

                Spacer()

                TransportationOptionsButton(viewModel: viewModel)
            }
            .padding()

            PlansDayView(viewModel: viewModel,
                         date: selectedDate,
                         plans: viewModel.getPlans(for: selectedDate),
                         onSelected: onSelected)
            .padding()
        }
        .onAppear {
            selectedDate = viewModel.getInitialDate()
        }
    }
}
