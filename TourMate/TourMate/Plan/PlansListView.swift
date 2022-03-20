//
//  PlansListView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansListView: View {
    @ObservedObject var plansViewModel: PlansViewModel

    typealias Day = (date: Date, plans: [Plan])
    var days: [Day] {
        let sortedPlans = plansViewModel.plans.sorted { plan1, plan2 in
            plan1.startDate < plan2.startDate
        }
        let plansByDay: [Date: [Plan]] = sortedPlans.reduce(into: [:]) { acc, cur in
            let components = Calendar.current.dateComponents(in: cur.startTimeZone, from: cur.startDate)
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
            let accommodationViewModel = PlanViewModel<Accommodation>(planId: plan.id)
            return AnyView(AccommodationView(accommodationViewModel: accommodationViewModel))
        case .activity:
            let activityViewModel = PlanViewModel<Activity>(planId: plan.id)
            return AnyView(ActivityView(activityViewModel: activityViewModel))
        case .restaurant:
            let restaurantViewModel = PlanViewModel<Restaurant>(planId: plan.id)
            return AnyView(RestaurantView(restaurantViewModel: restaurantViewModel))
        case .transport:
            let transportViewModel = PlanViewModel<Transport>(planId: plan.id)
            return AnyView(TransportView(transportViewModel: transportViewModel))
        case .flight:
            let flightViewModel = PlanViewModel<Flight>(planId: plan.id)
            return AnyView(FlightView(flightViewModel: flightViewModel))
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
                                         timeZone: plan.startTimeZone)
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
