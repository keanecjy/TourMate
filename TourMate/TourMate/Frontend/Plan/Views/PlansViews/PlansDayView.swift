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
    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime
    let onSelected: ((Plan) -> Void)?

    @State var planIdToSize: [String: CGSize] = [:]
    @State var planIdToOffset: [String: CGPoint] = [:]
    @State var minWidth: CGFloat = 0

    init(plans: [Plan] = [],
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         onSelected: ((Plan) -> Void)? = nil,
         hourHeight: Float = 64) {
        self.plans = plans
        print("plans:")
        print(plans)
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.onSelected = onSelected
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeStyle = .short
        self.hourHeight = hourHeight
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
        if !planIdRect.isEmpty {
            let firstPlanIdRect = planIdRect[0]
            planIdToOffset[firstPlanIdRect.planId] = CGPoint(x: 0, y: firstPlanIdRect.rect.origin.y)
            minWidth = firstPlanIdRect.rect.width
        }

        // Calculate and set X, Y offsets to not overlap
        for i in 1 ..< planIdRect.count {
            let prevPlanIdRect = planIdRect[i - 1]
            let prevPlanId = prevPlanIdRect.planId
            let prevRect = prevPlanIdRect.rect
            let currentPlanIdRect = planIdRect[i]
            let currentPlanId = currentPlanIdRect.planId
            let currentRect = currentPlanIdRect.rect

            // If Y position overlaps, offset to the right
            let prevEndY = prevRect.origin.y + prevRect.size.height
            let currentStartY = currentRect.origin.y
            if currentStartY < prevEndY {
                var prevEndX = prevRect.origin.x + prevRect.size.width
                if let offset = planIdToOffset[prevPlanId] {
                    prevEndX += offset.x
                }
                planIdToOffset[currentPlanId] = CGPoint(x: prevEndX, y: currentStartY)
                minWidth = max(minWidth, prevEndX + currentRect.width)
            } else {
                planIdToOffset[currentPlanId] = CGPoint(x: 0, y: currentStartY)
            }
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
                    ScrollView(.horizontal) {
                        VStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .topLeading) {
                                ForEach(plans, id: \.id) { plan in
                                    HStack {
                                        PlanCardView(viewModel:
                                                        PlanViewModel(plan: plan,
                                                                      lowerBoundDate: lowerBoundDate,
                                                                      upperBoundDate: upperBoundDate)
                                        )
                                        .onTapGesture(perform: {
                                            if let onSelected = onSelected {
                                                onSelected(plan)
                                            }
                                        })
                                        .frame(maxWidth: 480,
                                               minHeight: CGFloat(getHeight(for: plan)),
                                               alignment: .topLeading)
                                        .readSize { size in
                                            planIdToSize[plan.id] = size
                                            calculateOffsets()
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
                        .frame(minWidth: minWidth)
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
