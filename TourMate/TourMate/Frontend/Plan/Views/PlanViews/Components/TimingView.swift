//
//  TimingView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 1/4/22.
//

import SwiftUI

struct TimingView: View {
    let startDate: DateTime
    let endDate: DateTime

    @State private var dateFormatter = DateFormatter()

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "clock")
                .font(.title)

            VStack(alignment: .leading) {
                Text("From").font(.body).bold()
                Text(startDate.date, formatter: dateFormatter)
            }

            VStack(alignment: .leading) {
                Text("To").font(.body).bold()
                Text(endDate.date, formatter: dateFormatter)
            }
        }
        .onAppear {
            // the date time doesn't show upon exit screen -> re-enter screen if it is not initialised again
            dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            dateFormatter.timeZone = startDate.timeZone // By default we take the start time zone
        }
    }
}

// struct TimingView_Previews: PreviewProvider {
//    static var previews: some View {
//        @ObservedObject var planViewModel = PlanViewModel(plan: MockPlanService().plans[0], trip: MockTripService().trips[0])
//        return TimingView(plan: $planViewModel.plan)
//    }
// }
