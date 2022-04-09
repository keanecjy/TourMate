//
//  ContentView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/3/22.
//

import SwiftUI

@MainActor
struct ContentView: View {

    @State private var selectedTrip: Trip?

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        NavigationView {
            VStack {
                TripsView(viewModel: viewModelFactory.getTripsViewModel()) { trip in
                    selectedTrip = trip
                }

                if let selectedTrip = selectedTrip {
                    NavigationLink(isActive: .constant(true)) {
                        TripView(tripViewModel: viewModelFactory.getTripViewModel(trip: selectedTrip))
                    } label: {
                        EmptyView()
                    }
                }
            }
            .onAppear(perform: {
                selectedTrip = nil
            })
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
