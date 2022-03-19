//
//  TripDetailView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripView: View {
    @StateObject var plansViewModel: PlansViewModel

    @State var isActive = false

    let trip: Trip

    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = trip.timeZone
        let startDateString = dateFormatter.string(from: trip.startDate)
        let endDateString = dateFormatter.string(from: trip.endDate)
        return startDateString + " - " + endDateString
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                Text(dateString)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.bottom, .horizontal])

                AsyncImage(url: URL(string: trip.imageUrl!)) {
                    image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200, alignment: .center)
                        .clipped()
                } placeholder: {
                    Color.gray
                }

                PlansListView(plansViewModel.plans)
            }
        }
        .navigationTitle(trip.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(isActive: $isActive) {
                    AddPlanView(isActive: $isActive, trip: trip)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            plansViewModel.tripId = trip.id
        }
        .task {
            await plansViewModel.fetchPlans()
        }
    }
}

// struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(trip).environmentObject(MockModel())
//    }
// }
