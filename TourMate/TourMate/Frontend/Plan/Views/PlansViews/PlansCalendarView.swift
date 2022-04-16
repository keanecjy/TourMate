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
    @State private var isShowingTransportationOptionsSheet = false

    let onSelected: ((Plan) -> Void)?

    init(viewModel: PlansViewModel, onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSelected = onSelected
    }

    func getPlans(for date: Date) -> [Plan] {
        viewModel.days.first { $0.date == date }?.plans ?? []
    }

    var body: some View {
        LazyVStack {
            HStack {
                Picker("Date", selection: $selectedDate) {
                    ForEach(viewModel.days, id: \.date) { day in
                        PlanDateView(date: day.date, timeZone: Calendar.current.timeZone)
                    }
                }
                .pickerStyle(.menu)
                .padding([.horizontal])
                .background(
                    Capsule().fill(Color.primary.opacity(0.25))
                )

                Button {
                    isShowingTransportationOptionsSheet.toggle()
                } label: {
                    Text("Search for Transportation")

                }
                .font(.system(size: 15))
                .padding(6)
                .background(
                    Capsule().fill(Color.primary.opacity(0.25))
                )
                .sheet(isPresented: $isShowingTransportationOptionsSheet) {
                    TransportationOptionsView()
                }

                Spacer()
            }
            .padding()

            PlansDayView(viewModel: viewModel,
                         date: selectedDate,
                         plans: getPlans(for: selectedDate),
                         onSelected: onSelected)
            .padding()
        }
        .task {
            selectedDate = viewModel.days.first?.date ?? Date()
        }
    }
}
