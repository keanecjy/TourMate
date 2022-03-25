//
//  TripView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: TripViewModel

    @State private var isAddPlanViewActive = false
    @State private var isShowingEditTripSheet = false

    init(trip: Trip) {
        self._viewModel = StateObject(wrappedValue: TripViewModel(trip: trip))
    }

    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = viewModel.trip.startDateTime.timeZone
        let startDateString = dateFormatter.string(from: viewModel.trip.startDateTime.date)
        dateFormatter.timeZone = viewModel.trip.endDateTime.timeZone
        let endDateString = dateFormatter.string(from: viewModel.trip.endDateTime.date)
        return startDateString + " - " + endDateString
    }

    func refreshTrip() async {
        await viewModel.fetchTrip()
        if viewModel.isDeleted {
            dismiss()
        }
    }

    @ViewBuilder
    var body: some View {
        Group {
            if viewModel.hasError {
                Text("Error occurred")
            } else if viewModel.isLoading || viewModel.isDeleted {
                ProgressView()
            } else {
                ScrollView {
                    VStack {
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

                        PlansListView(tripId: viewModel.trip.id)
                    }
                }
            }
        }
        .navigationTitle(viewModel.trip.name)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isShowingEditTripSheet.toggle()
                } label: {
                    Image(systemName: "pencil").contentShape(Rectangle())
                }
                .disabled(viewModel.isLoading || viewModel.isDeleted || viewModel.isLoading)
                .sheet(isPresented: $isShowingEditTripSheet) {
                    Task {
                        await refreshTrip()
                    }
                } content: {
                    EditTripView(trip: viewModel.trip)
                }

                NavigationLink(isActive: $isAddPlanViewActive) {
                    AddPlanView(isActive: $isAddPlanViewActive, trip: viewModel.trip)
                } label: {
                    Image(systemName: "plus").contentShape(Rectangle())
                }
                .disabled(viewModel.isLoading || viewModel.isDeleted || viewModel.isLoading)
            }
        }
        .task {
            await refreshTrip()
        }
    }
}

// struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(trip).environmentObject(MockModel())
//    }
// }
