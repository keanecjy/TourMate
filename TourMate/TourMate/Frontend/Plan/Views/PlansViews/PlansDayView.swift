//
//  PlansDayView.swift
//  TourMate
//
//  Created by Rayner Lim on 28/3/22.
//

import SwiftUI

struct PlansDayView: View {
    let plans: [Plan]
    let dateFormatter: DateFormatter
    let hourHeight: Float

    @ObservedObject var tripViewModel: TripViewModel

    @State var planIdToSize: [String: CGSize] = [:]
    @State var planIdToOffset: [String: CGPoint] = [:]

    init(tripViewModel: TripViewModel, plans: [Plan] = [], hourHeight: Float = 50) {
        self.plans = plans
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeStyle = .short
        self.hourHeight = hourHeight
        self.tripViewModel = tripViewModel
    }

    // TODO: use DateFormatter
    func getHourString(for hour: Int) -> String {
        if hour == 0 || hour == 24 {
            return "12 AM"
        } else if hour < 12 {
            return "\(hour) AM"
        } else if hour == 12 {
            return "12 PM"
        } else {
            return "\(hour - 12) PM"
        }
    }

    func getYPosition(for plan: Plan) -> (start: Float, end: Float) {
        let startDateComponents = Calendar
            .current
            .dateComponents(in: plan.startDateTime.timeZone, from: plan.startDateTime.date)
        let endDateComponents = Calendar
            .current
            .dateComponents(in: plan.endDateTime.timeZone, from: plan.endDateTime.date)
        let start = (Float(startDateComponents.hour ?? 0) + Float(startDateComponents.minute ?? 0) / 60) * hourHeight
        let end = (Float(endDateComponents.hour ?? 0) + Float(endDateComponents.minute ?? 0) / 60) * hourHeight
        return (start: start, end: end)
    }

    func getHeight(for plan: Plan) -> Float {
        let yPosition = getYPosition(for: plan)
        return yPosition.end - yPosition.start
    }

    func calculateOffsets() {
        var planIdRect: [(planId: String, rect: CGRect)] = []

        // Get initial rects
        for plan in plans {
            let origin = CGPoint(x: CGFloat(0.0), y: CGFloat(getYPosition(for: plan).start))
            let size = planIdToSize[plan.id] ?? CGSize(width: 0, height: 0)
            let rect = CGRect(origin: origin, size: size)
            planIdRect.append((planId: plan.id, rect: rect))
        }

        // Set Y offset for first plan
        let firstPlanIdRect = planIdRect[0]
        planIdToOffset[firstPlanIdRect.planId] = CGPoint(x: 0, y: firstPlanIdRect.rect.origin.y)

        // Calculate and set X, Y offsets to not overlap
        for i in 1...(planIdRect.count - 1) {
            let prevPlanIdRect = planIdRect[i - 1]
            let prevPlanId = prevPlanIdRect.planId
            let prevRect = prevPlanIdRect.rect
            let currentPlanIdRect = planIdRect[i]
            let currentPlanId = currentPlanIdRect.planId
            let currentRect = currentPlanIdRect.rect

            let prevEndY = prevRect.origin.y + prevRect.size.height
            let currentStartY = currentRect.origin.y
            // offset to the right
            if currentStartY < prevEndY {
                var prevEndX = prevRect.origin.x + prevRect.size.width
                if let offset = planIdToOffset[prevPlanId] {
                    prevEndX += offset.x
                }
                planIdToOffset[currentPlanId] = CGPoint(x: prevEndX, y: currentStartY)
            } else {
                planIdToOffset[currentPlanId] = CGPoint(x: 0, y: currentStartY)
            }
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

    func createUpvoteView(_ plan: Plan) -> some View {
        switch plan.planType {
        case .accommodation:
            let accommodationViewModel = PlanViewModel<Accommodation>(plan: plan as! Accommodation, trip: tripViewModel.trip)
            return AnyView(UpvotePlanView(viewModel: accommodationViewModel, displayName: false))
        case .activity:
            let activityViewModel = PlanViewModel<Activity>(plan: plan as! Activity, trip: tripViewModel.trip)
            return AnyView(UpvotePlanView(viewModel: activityViewModel, displayName: false))
        case .restaurant:
            let restaurantViewModel = PlanViewModel<Restaurant>(plan: plan as! Restaurant, trip: tripViewModel.trip)
            return AnyView(UpvotePlanView(viewModel: restaurantViewModel, displayName: false))
        case .transport:
            let transportViewModel = PlanViewModel<Transport>(plan: plan as! Transport, trip: tripViewModel.trip)
            return AnyView(UpvotePlanView(viewModel: transportViewModel, displayName: false))
        case .flight:
            let flightViewModel = PlanViewModel<Flight>(plan: plan as! Flight, trip: tripViewModel.trip)
            return AnyView(UpvotePlanView(viewModel: flightViewModel, displayName: false))
        }
    }

    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0...24, id: \.self) { hour in
                        VStack {
                            Text(getHourString(for: hour))
                                .font(.caption)
                            Spacer()
                        }
                        .frame(height: CGFloat(hourHeight))
                    }
                }
                ZStack {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            ForEach(plans, id: \.id) { plan in
                                HStack {
                                    NavigationLink {
                                        createPlanView(plan)
                                    } label: {
                                        PlanBoxView(
                                            title: plan.name,
                                            startDate: plan.startDateTime.date,
                                            endDate: plan.endDateTime.date,
                                            timeZone: plan.startDateTime.timeZone,
                                            status: plan.status
                                        )
                                        .frame(minHeight: CGFloat(getHeight(for: plan)))
                                        .readSize { size in
                                            planIdToSize[plan.id] = size
                                            calculateOffsets()
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.primary.opacity(0.25))
                                    )
                                    .offset(x: CGFloat(planIdToOffset[plan.id]?.x ?? 0),
                                            y: CGFloat(planIdToOffset[plan.id]?.y ?? 0) + 7)
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0...24, id: \.self) { _ in
                            VStack(alignment: .leading, spacing: 0) {
                                Rectangle()
                                    .fill(Color.primary.opacity(0.1))
                                    .frame(height: 2)
                                Spacer()
                            }
                            .frame(height: CGFloat(hourHeight))
                            .offset(y: 6)
                        }
                    }
                }
            }

        }
    }
}

/*
struct PlansDayView_Previews: PreviewProvider {
    static var previews: some View {
        PlansDayView()
    }
}
 */
