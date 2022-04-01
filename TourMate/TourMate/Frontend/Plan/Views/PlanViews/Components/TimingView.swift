//
//  TimingView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 1/4/22.
//

import SwiftUI

struct TimingView: View {
    @Binding var plan: Plan
    let dateFormatter: DateFormatter

    init(plan: Binding<Plan>) {
        _plan = plan
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
    }
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "clock")
                .font(.title)
            VStack(alignment: .leading) {
                Text("From").font(.caption)
                Text(plan.startDateTime.date, formatter: dateFormatter)
                Text("To").font(.caption)
                Text(plan.endDateTime.date, formatter: dateFormatter)
            }
        }
    }
}

// struct TimingView_Previews: PreviewProvider {
//    static var previews: some View {
//        @ObservedObject var planViewModel = PlanViewModel(plan: MockPlanService().plans[0], trip: MockTripService().trips[0])
//        return TimingView(plan: $planViewModel.plan)
//    }
// }
