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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = activityViewModel.plan.startDateTime.timeZone
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
                                UpvotePlanView(viewModel: activityViewModel)
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

                        CommentsView(commentsViewModel: activityViewModel.commentsViewModel)
                            .padding()

                        Spacer()
                    }

                    Spacer()
                }
            }
            .navigationBarTitle(activityViewModel.plan.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditActivityView(viewModel: activityViewModel)
                    }
                }
            }
            .task {
                await activityViewModel.fetchPlanAndListen()
            }
            .onReceive(activityViewModel.objectWillChange) {
                if activityViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in activityViewModel.detachListener() })
        }
    }
}

// struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView()
//    }
// }
