//
//  TripDetailView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripView: View {
    @EnvironmentObject var model: MockModel

    @State private var isActive = false
    @State private var isShowingEditTripSheet = false

    private var trip: Trip

    init(trip: Trip) {
        self.trip = trip
    }

    var plans: [Plan] {
        model.getPlans(forTripId: trip.id)
    }

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

                if let imageUrl = trip.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200, alignment: .center)
                            .clipped()
                    } placeholder: {
                        Color.gray
                    }
                }

                PlansListView(model.getPlans(forTripId: trip.id))
            }
        }
        .navigationTitle(trip.name)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isShowingEditTripSheet.toggle()
                } label: {
                    Image(systemName: "pencil")
                }
                .sheet(isPresented: $isShowingEditTripSheet) {
                    EditTripView(trip: trip)
                }

                NavigationLink(isActive: $isActive) {
                    AddPlanView(isActive: $isActive)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

// struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(trip).environmentObject(MockModel())
//    }
// }
