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

    @State private var selectedPlan: Plan?
    private let viewModelFactory: ViewModelFactory
    private let viewFactory: ViewFactory

    init(tripViewModel: TripViewModel) {
        self.viewModelFactory = ViewModelFactory()
        self.viewFactory = ViewFactory()
        self._viewModel = StateObject(wrappedValue: tripViewModel)
    }

    @ViewBuilder
    var body: some View {
        Group {
            if viewModel.hasError {
                Text("Error occurred")
            } else if viewModel.isLoading || viewModel.isDeleted {
                ProgressView()
            } else {
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        TripImage(imageUrl: viewModel.imageUrlDisplay)
                            .overlay(Color.primary.colorInvert().opacity(0.75))
                        HStack(alignment: .center) {
                            Text(viewModel.durationDisplay)
                                .font(.headline)
                            ScrollView(.horizontal) {
                                AttendeesView(attendees: viewModel.attendees)
                            }
                        }
                        .padding([.horizontal])
                    }

                    PlansView(plansViewModel: viewModelFactory.getPlansViewModel(tripViewModel: viewModel)) { plan in
                        selectedPlan = plan
                    }

                    if let selectedPlan = selectedPlan {
                        NavigationLink(isActive: .constant(true)) {
                            viewFactory.getPlanView(plan: selectedPlan, tripViewModel: viewModel)
                        } label: {
                            EmptyView()
                        }
                    }
                }
                .onAppear(perform: {
                    selectedPlan = nil
                })
                .ignoresSafeArea()
            }
        }
        .navigationTitle(viewModel.nameDisplay)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {

                EditTripButton(viewModel: viewModel)

                InviteUserButton(viewModel: viewModel)

                AddPlanSelectionButton(viewModel: viewModel)
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
