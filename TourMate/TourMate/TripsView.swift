//
//  TripsView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripsView: View {
    @EnvironmentObject var model: MockModel

    /// Fetch Trips using userId
    func getTrips(forUserId userId: String) -> [Trip] {
        model.getTrips(forUserId: userId)
    }

    func getDateString(tripId: String) -> String {
        let trip = model.getTrip(withTripId: tripId)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = trip.timeZone
        let startDateString = dateFormatter.string(from: trip.startDate)
        let endDateString = dateFormatter.string(from: trip.endDate)
        return startDateString + " - " + endDateString
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(model.trips, id: \.id) { trip in
                        NavigationLink {
                            TripView(model.getTrip(withTripId: trip.id))
                        } label: {
                            TripCardView(title: trip.name,
                                         subtitle: getDateString(tripId: trip.id),
                                         imageUrl: trip.imageUrl!)
                        }
                    }
                }
            }
            .navigationTitle("Trips")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        TripFormView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {

            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView().environmentObject(MockModel())
    }
}
