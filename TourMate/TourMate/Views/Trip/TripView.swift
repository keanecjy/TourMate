//
//  TripDetailView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripView: View {
    @StateObject var plansViewModel: PlansViewModel
    @StateObject var viewModel: TripViewModel

    @State private var isActive = false
    @State private var isShowingEditTripSheet = false

    init(trip: Trip) {
        self._plansViewModel = StateObject(wrappedValue: PlansViewModel(tripId: trip.id))
        self._viewModel = StateObject(wrappedValue: TripViewModel(trip: trip))
    }

    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = viewModel.trip.timeZone
        let startDateString = dateFormatter.string(from: viewModel.trip.startDate)
        let endDateString = dateFormatter.string(from: viewModel.trip.endDate)
        return startDateString + " - " + endDateString
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                Text(dateString)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.bottom, .horizontal])

                if let imageUrl = viewModel.trip.imageUrl {
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

                PlansListView(plansViewModel: plansViewModel)
            }
        }
        .navigationTitle(viewModel.trip.name)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isShowingEditTripSheet.toggle()
                } label: {
                    Image(systemName: "pencil")
                }
                .sheet(isPresented: $isShowingEditTripSheet) {
                    EditTripView(trip: viewModel.trip)
                }

                NavigationLink(isActive: $isActive) {
                    AddPlanView(isActive: $isActive, trip: viewModel.trip)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            /*
            await viewModel.refreshTrip()
            print("[TripView] Refreshed trip: \(viewModel.trip)")
            */

            await plansViewModel.fetchPlans()
            print("[TripView] Fetched: \(plansViewModel.plans)")
        }
    }
}

// struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(trip).environmentObject(MockModel())
//    }
// }
