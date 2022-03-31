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
                        Text(viewModel.trip.durationDescription)
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
                        Text("Attendees")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.bottom, .horizontal])

                        AttendeesView(viewModel: viewModel)

                        PlansListView(tripId: viewModel.trip.id, tripViewModel: viewModel)
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
                .disabled(viewModel.isDeleted || viewModel.isLoading)
                .sheet(isPresented: $isShowingEditTripSheet) {
                    EditTripView(trip: viewModel.trip)
                }

                NavigationLink(isActive: $isAddPlanViewActive) {
                    AddPlanView(isActive: $isAddPlanViewActive, tripViewModel: viewModel)
                } label: {
                    Image(systemName: "plus").contentShape(Rectangle())
                }
                .disabled(viewModel.isDeleted || viewModel.isLoading)
            }
        }
        .task {
            await viewModel.fetchTripAndListen()
        }
        .onReceive(viewModel.objectWillChange) {
            if viewModel.isDeleted {
                dismiss()
            }
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}

// struct TripView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripView(trip).environmentObject(MockModel())
//    }
// }
