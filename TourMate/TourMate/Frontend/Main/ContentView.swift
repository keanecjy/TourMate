//
//  ContentView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/3/22.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedTrip: Trip?

    var body: some View {
        NavigationView {
            VStack {
                TripsView(viewModel: TripsViewModel()) { trip in
                    selectedTrip = trip
                }

                if let selectedTrip = selectedTrip {
                    NavigationLink(isActive: .constant(true)) {
                        TripView(tripViewModel: TripViewModel(trip: selectedTrip))
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
