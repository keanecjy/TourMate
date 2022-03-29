//
//  PlanFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

@MainActor
struct AddPlanView: View {
    @Binding var isActive: Bool

    var tripViewModel: TripViewModel

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

    private func createFormView(planType: PlanType) -> some View {
        let trip = tripViewModel.trip
        let tripId = trip.id
        let planId = tripId + UUID().uuidString
        let startDateTime = trip.startDateTime
        let endDateTime = trip.startDateTime

        switch planType {
        case .accommodation:
            let accommodation = Accommodation(id: planId,
                                              tripId: tripId,
                                              name: "",
                                              startDateTime: startDateTime,
                                              endDateTime: endDateTime,
                                              startLocation: "",
                                              status: .confirmed,
                                              creationDate: Date(),
                                              modificationDate: Date(),
                                              upvotedUserIds: [])
            let addAccommodationFormViewModel = AddPlanFormViewModel(plan: accommodation, trip: trip)
            return AnyView(AccommodationFormView(isActive: $isActive, viewModel: addAccommodationFormViewModel))
        case .activity:
            let activity = Activity(id: planId, tripId: tripId,
                                    name: "",
                                    startDateTime: startDateTime,
                                    endDateTime: endDateTime,
                                    startLocation: "",
                                    status: .confirmed,
                                    creationDate: Date(),
                                    modificationDate: Date(),
                                    upvotedUserIds: [])
            let addActivityFormViewModel = AddPlanFormViewModel(plan: activity, trip: trip)
            return AnyView(ActivityFormView(isActive: $isActive, viewModel: addActivityFormViewModel))
        case .restaurant:
            let restaurant = Restaurant(id: planId, tripId: tripId,
                                        name: "",
                                        startDateTime: startDateTime,
                                        endDateTime: endDateTime,
                                        startLocation: "",
                                        status: .confirmed,
                                        creationDate: Date(),
                                        modificationDate: Date(),
                                        upvotedUserIds: [])
            let addRestaurantFormViewModel = AddPlanFormViewModel(plan: restaurant, trip: trip)
            return AnyView(RestaurantFormView(isActive: $isActive, viewModel: addRestaurantFormViewModel))
        case .transport:
            let transport = Transport(id: planId, tripId: tripId,
                                      name: "",
                                      startDateTime: startDateTime,
                                      endDateTime: endDateTime,
                                      startLocation: "",
                                      status: .confirmed,
                                      creationDate: Date(),
                                      modificationDate: Date(),
                                      upvotedUserIds: [])
            let addTransportFormViewModel = AddPlanFormViewModel(plan: transport, trip: trip)
            return AnyView(TransportFormView(isActive: $isActive, viewModel: addTransportFormViewModel))
        case .flight:
            let flight = Flight(id: planId, tripId: tripId,
                                name: "",
                                startDateTime: startDateTime,
                                endDateTime: endDateTime,
                                startLocation: "",
                                status: .confirmed,
                                creationDate: Date(),
                                modificationDate: Date(),
                                upvotedUserIds: [])
            let addFlightFormViewModel = AddPlanFormViewModel(plan: flight, trip: trip)
            return AnyView(FlightFormView(isActive: $isActive, viewModel: addFlightFormViewModel))
        }
    }

    var accommodation: some View {
        NavigationLink {
            createFormView(planType: .accommodation)
        } label: {
            Text("Accommodation")
        }
    }

    var activity: some View {
        NavigationLink {
            createFormView(planType: .activity)
        } label: {
            Text("Activity")
        }
    }

    var restaurant: some View {
        NavigationLink {
            createFormView(planType: .restaurant)
        } label: {
            Text("Restaurant")
        }
    }

    var transport: some View {
        NavigationLink {
            createFormView(planType: .transport)
        } label: {
            Text("Transportation")
        }
    }

    var flight: some View {
        NavigationLink {
            createFormView(planType: .flight)
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
