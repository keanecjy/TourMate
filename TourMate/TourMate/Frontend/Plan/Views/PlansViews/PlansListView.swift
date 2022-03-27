//
//  PlansListView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlansListView: View {
    @StateObject var plansViewModel: PlansViewModel
    var tripViewModel: TripViewModel

    init(tripId: String, tripViewModel: TripViewModel) {
        self._plansViewModel = StateObject(wrappedValue: PlansViewModel(tripId: tripId))
        self.tripViewModel = tripViewModel
    }

    typealias Day = (date: Date, plans: [Plan])
    var days: [Day] {
        let sortedPlans = plansViewModel.plans.sorted { plan1, plan2 in
            plan1.startDateTime.date < plan2.startDateTime.date
        }
        let plansByDay: [Date: [Plan]] = sortedPlans.reduce(into: [:]) { acc, cur in
            let components = Calendar
                .current
                .dateComponents(in: cur.startDateTime.timeZone, from: cur.startDateTime.date)
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
            let accommodationViewModel = PlanViewModel<Accommodation>(
                plan: plan as! Accommodation, trip: tripViewModel.trip)
            return AnyView(AccommodationView(accommodationViewModel: accommodationViewModel))
        case .activity:
            let activityViewModel = PlanViewModel<Activity>(
                plan: plan as! Activity, trip: tripViewModel.trip)
            return AnyView(ActivityView(activityViewModel: activityViewModel))
        case .restaurant:
            let restaurantViewModel = PlanViewModel<Restaurant>(
                plan: plan as! Restaurant, trip: tripViewModel.trip)
            return AnyView(RestaurantView(restaurantViewModel: restaurantViewModel))
        case .transport:
            let transportViewModel = PlanViewModel<Transport>(
                plan: plan as! Transport, trip: tripViewModel.trip)
            return AnyView(TransportView(transportViewModel: transportViewModel))
        case .flight:
            let flightViewModel = PlanViewModel<Flight>(
                plan: plan as! Flight, trip: tripViewModel.trip)
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
                                         startDate: plan.startDateTime.date,
                                         endDate: plan.endDateTime.date,
                                         timeZone: plan.startDateTime.timeZone)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .task {
            await plansViewModel.fetchPlans()
            print("[PlansListView] Fetched plans: \(plansViewModel.plans)")
        }
    }
}

// struct PlansListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlansListView(id: 0).environmentObject(MockModel())
//    }
// }
