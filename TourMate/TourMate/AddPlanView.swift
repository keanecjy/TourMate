//
//  PlanFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AddPlanView: View {

    @Binding var isActive: Bool

    let trip: Trip

    var body: some View {
        List {
            accommodation
            activity
            restaurant
            transport
            flight
        }
        .navigationBarTitle("Add Plan")
        .navigationBarTitleDisplayMode(.inline)
    }

    var accommodation: some View {
        NavigationLink {
            AccommodationFormView(isActive: $isActive, tripId: trip.id)
        } label: {
            Text("Accommodation")
        }
    }

    var activity: some View {
        NavigationLink {
            ActivityFormView(isActive: $isActive, tripId: trip.id)
        } label: {
            Text("Activity")
        }
    }

    var restaurant: some View {
        NavigationLink {
            RestaurantFormView(isActive: $isActive, tripId: trip.id)
        } label: {
            Text("Restaurant")
        }
    }

    var transport: some View {
        NavigationLink {
            TransportFormView(isActive: $isActive, tripId: trip.id)
        } label: {
            Text("Transportation")
        }
    }

    var flight: some View {
        NavigationLink {
            FlightFormView(isActive: $isActive, tripId: trip.id)
        } label: {
            Text("Flight")
        }
    }
}

// struct PlanFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPlanView()
//    }
// }
