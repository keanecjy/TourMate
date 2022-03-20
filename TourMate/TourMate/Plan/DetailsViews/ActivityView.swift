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

    func getDateString(_ date: Date) -> String {
        guard let activity = activityViewModel.plan else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = activity.startTimeZone
        return dateFormatter.string(from: date)
    }

    var body: some View {
        HStack {
            if let activity = activityViewModel.plan {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        // Start Time
                        Text("From")
                            .font(.caption)
                        Text(getDateString(activity.startDate))
                            .font(.headline)

                        // End Time
                        if let endDate = activity.endDate {
                            Text("To")
                                .font(.caption)
                            Text(getDateString(endDate))
                                .font(.headline)
                        }
                    }
                    .padding()

                    VStack(alignment: .leading) {
                        if let venue = activity.venue {
                            Text("Venue")
                                .font(.caption)
                            Text(venue)
                        }

                        if let address = activity.address {
                            Text("Address")
                                .font(.caption)
                            Text(address)
                        }
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
                    Text("Present Activity Edit View")
                    // Edit Plan
                    // After edit -> fetch Plan
                    // If nothing is fetched -> dismiss this view
                }
            }
        }
        .task {
            await activityViewModel.fetchPlan()
        }
    }
}

// struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView()
//    }
// }
