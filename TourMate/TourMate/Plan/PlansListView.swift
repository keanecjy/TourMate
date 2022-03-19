//
//  PlansListView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansListView: View {

    private var plans: [Plan]

    init(_ plans: [Plan]) {
        self.plans = plans
    }

    typealias Day = (date: Date, plans: [Plan])
    var days: [Day] {
        let sortedPlans = plans.sorted { plan1, plan2 in
            plan1.startDate < plan2.startDate
        }
        let plansByDay: [Date: [Plan]] = sortedPlans.reduce(into: [:]) { acc, cur in
            let components = Calendar.current.dateComponents(in: cur.timeZone, from: cur.startDate)
            let dateComponents = DateComponents(year: components.year,
                                                month: components.month,
                                                day: components.day)
            let date = Calendar.current.date(from: dateComponents)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        return plansByDay.sorted(by: { $0.key < $1.key }).map { day in
            (date: day.key, plans: day.value)
        }
    }

    func createPlanView(_ plan: Plan) -> some View {
        switch plan.planType {
        case .accommodation:
            guard let accommodation = plan as? Accommodation else {
                preconditionFailure()
            }
            return AnyView(AccommodationView(accommodation: accommodation))
        case .activity:
            guard let activity = plan as? Activity else {
                preconditionFailure()
            }
            return AnyView(ActivityView(activity: activity))
        case .restaurant:
            guard let restaurant = plan as? Restaurant else {
                preconditionFailure()
            }
            return AnyView(RestaurantView(restaurant: restaurant))
        case .transport:
            guard let transport = plan as? Transport else {
                preconditionFailure()
            }
            return AnyView(TransportView(transport: transport))
        case .flight:
            guard let flight = plan as? Flight else {
                preconditionFailure()
            }
            return AnyView(FlightView(flight: flight))
        }
    }

    var body: some View {

        LazyVStack {
            ForEach(days, id: \.date) { day in
                VStack(alignment: .leading) {
                    PlanHeaderView(date: day.date, timeZone: Calendar.current.timeZone)

                    ForEach(day.plans, id: \.id) { plan in
                        NavigationLink {
                            createPlanView(plan)
                        } label: {
                            PlanCardView(title: plan.name,
                                         startDate: plan.startDate,
                                         endDate: plan.endDate,
                                         timeZone: plan.timeZone)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
    }
}

// struct PlansListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlansListView(id: 0).environmentObject(MockModel())
//    }
// }
