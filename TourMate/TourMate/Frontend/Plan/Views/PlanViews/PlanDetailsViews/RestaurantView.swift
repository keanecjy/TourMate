//
//  RestaurantView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct RestaurantView: View {
    @StateObject var restaurantViewModel: PlanViewModel<Restaurant>
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = restaurantViewModel.plan.startDateTime.timeZone
        return dateFormatter.string(from: date)
    }

    var body: some View {
        if restaurantViewModel.hasError {
            Text("Error occurred")
        } else {
            HStack {
                if let restaurant = restaurantViewModel.plan {
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            PlanStatusView(status: restaurant.status)
                                .padding()

                            if restaurant.status == .proposed {
                                UpvotePlanView(viewModel: restaurantViewModel)
                            }
                        }

                        // Start time
                        VStack(alignment: .leading) {
                            Text("From")
                                .font(.caption)
                            Text(getDateString(restaurant.startDateTime.date))
                                .font(.headline)

                            Text("To")
                                .font(.caption)
                            Text(getDateString(restaurant.endDateTime.date))
                                .font(.headline)
                        }
                        .padding()

                        // Adress
                        VStack(alignment: .leading) {
                            Text("Address")
                                .font(.caption)
                            Text(restaurant.startLocation?.addressFull ?? "")
                        }
                        .padding()

                        // Phone number
                        if let phone = restaurant.phone {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text(phone)
                            }
                            .padding()
                        }

                        // Website
                        if let website = restaurant.website {
                            HStack {
                                Image(systemName: "globe.americas.fill")
                                Text(website)
                            }
                            .padding()
                        }

                        CommentsView(commentsViewModel: restaurantViewModel.commentsViewModel)
                            .padding()

                        Spacer()
                    }

                    Spacer()
                }
            }
            .navigationBarTitle(restaurantViewModel.plan.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditRestaurantView(viewModel: restaurantViewModel)
                    }
                }
            }
            .task {
                await restaurantViewModel.fetchPlanAndListen()
            }
            .onReceive(restaurantViewModel.objectWillChange) {
                if restaurantViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in restaurantViewModel.detachListener() })
        }
    }
}

// struct RestaurantView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantView()
//    }
// }
