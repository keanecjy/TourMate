//
//  ActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var activityViewModel: PlanViewModel<Activity>
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    func getDateString(_ date: Date) -> String {
        guard let activity = activityViewModel.plan else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = activity.startDateTime.timeZone
        return dateFormatter.string(from: date)
    }

    var body: some View {
        if activityViewModel.hasError {
            Text("Error occurred")
        } else {
            HStack {
                if let activity = activityViewModel.plan {
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            PlanStatusView(status: activity.status)
                                .padding()

                            if activity.status == .proposed {
                                UpvoteButton(hasUpvoted: activityViewModel.userHasUpvotedPlan,
                                             action: activityViewModel.upvotePlan)
                            }
                        }

                        VStack(alignment: .leading) {
                            // Start Time
                            Text("From")
                                .font(.caption)
                            Text(getDateString(activity.startDateTime.date))
                                .font(.headline)

                            // End Time
                            Text("To")
                                .font(.caption)
                            Text(getDateString(activity.endDateTime.date))
                                .font(.headline)
                        }
                        .padding()

                        VStack(alignment: .leading) {
                            if let venue = activity.venue {
                                Text("Venue")
                                    .font(.caption)
                                Text(venue)
                            }

                            Text("Address")
                                .font(.caption)
                            Text(activity.startLocation)
                        }
                        .padding()

                        // Phone number
                        if let phone = activity.phone {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text(phone)
                            }
                            .padding()
                        }

                        // Website
                        if let website = activity.website {
                            HStack {
                                Image(systemName: "globe.americas.fill")
                                Text(website)
                            }
                            .padding()
                        }

                        Spacer()
                    }

                    Spacer()
                }
            }
            .navigationBarTitle(activityViewModel.plan?.name ?? "Activity")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        // Edit Plan
                        // After edit -> fetch Plan
                        // If nothing is fetched -> dismiss this view

                        // on dismiss
                        Task {
                            await activityViewModel.fetchPlan()

                            // TODO: UI Fix
                            // There is a lag between setting the plan to nil
                            // And when we dismiss this view
                            // Maybe need to see how to change the logic
                            if activityViewModel.plan == nil {
                                dismiss()
                            }
                        }
                    } content: {
                        if let activity = activityViewModel.plan {
                            EditActivityView(activity: activity)
                        } else {
                            Text("Error")
                        }
                    }
                }
            }
            .task {
                await activityViewModel.fetchPlan()
            }
        }
    }
}

// struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView()
//    }
// }
