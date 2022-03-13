//
//  TripDetailView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripView: View {
    @EnvironmentObject var model: MockModel

    @State var id: Int
    @State private var isActive = false

    var body: some View {
        let trip = model.trips[id]

        return ItineraryView(id: id)
            .navigationTitle(trip.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(isActive: $isActive) {
                        AddPlanView(isActive: $isActive)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(id: 0).environmentObject(MockModel())
    }
}
