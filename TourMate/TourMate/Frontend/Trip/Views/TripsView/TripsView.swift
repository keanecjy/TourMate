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
                                         subtitle: trip.durationDescription,
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
            await viewModel.fetchTripsAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView(viewModel: TripsViewModel(tripService: MockTripService()))
    }
}
