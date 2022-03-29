//
//  TripsView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripsView: View {
    @StateObject var viewModel = TripsViewModel()
    @State private var isShowingAddTripSheet = false

    func getDateString(trip: Trip) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = trip.startDateTime.timeZone
        let startDateString = dateFormatter.string(from: trip.startDateTime.date)
        dateFormatter.timeZone = trip.endDateTime.timeZone
        let endDateString = dateFormatter.string(from: trip.endDateTime.date)
        return startDateString + " - " + endDateString
    }

    var body: some View {
        Group {
            if viewModel.hasError {
                Text("Error occurred")
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.trips, id: \.id) { trip in
                            NavigationLink {
                                TripView(trip: trip)
                            } label: {
                                TripCard(title: trip.name,
                                         subtitle: getDateString(trip: trip),
                                         imageUrl: trip.imageUrl ?? "")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Trips")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isShowingAddTripSheet.toggle()
                } label: {
                    Image(systemName: "plus").contentShape(Rectangle())
                }
                .disabled(viewModel.isLoading || viewModel.hasError)
                .sheet(isPresented: $isShowingAddTripSheet) {
                    Task {
                        await viewModel.fetchTrips()
                    }
                } content: {
                    AddTripView()
                }

                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "person.circle.fill").contentShape(Rectangle())
                }
            }
        }
        .task {
            await viewModel.fetchTrips()
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView(viewModel: TripsViewModel(tripService: MockTripService()))
    }
}
