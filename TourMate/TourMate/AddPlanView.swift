//
//  PlanFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AddPlanView: View {
    @Binding var isActive: Bool

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
            AccommodationFormView(isActive: $isActive)
        } label: {
            Text("Accommodation")
        }
    }

    var activity: some View {
        NavigationLink {
            ActivityFormView(isActive: $isActive)
        } label: {
            Text("Activity")
        }
    }

    var restaurant: some View {
        NavigationLink {
            RestaurantFormView(isActive: $isActive)
        } label: {
            Text("Restaurant")
        }
    }

    var transport: some View {
        NavigationLink {
            TransportFormView(isActive: $isActive)
        } label: {
            Text("Transportation")
        }
    }

    var flight: some View {
        NavigationLink {
            FlightFormView(isActive: $isActive)
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
