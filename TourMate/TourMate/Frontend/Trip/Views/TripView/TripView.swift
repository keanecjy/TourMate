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

    @State private var isShowingAddPlanSheet = false
    @State private var isShowingEditTripSheet = false
    @State private var isShowingInviteUsersSheet = false

    @State private var selectedPlan: Plan?

    init(tripViewModel: TripViewModel) {
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
                ScrollView {
                    VStack {
                        Text(viewModel.durationDisplay)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal])

                        AttendeesView(attendees: viewModel.attendees)

                        TripImage(imageUrl: viewModel.imageUrlDisplay)

                        PlansView(plansViewModel: ViewModelFactory.getPlansViewModel(tripViewModel: viewModel)) { plan in
                            selectedPlan = plan
                        }

                        if let selectedPlan = selectedPlan {
                            NavigationLink(isActive: .constant(true)) {
                                PlanView(planViewModel: ViewModelFactory.getPlanViewModel(plan: selectedPlan,
                                                                                          tripViewModel: viewModel))
                            } label: {
                                EmptyView()
                            }
                        }
                    }
                    .onAppear(perform: {
                        selectedPlan = nil
                    })
                }
            }
        }
        .navigationTitle(viewModel.nameDisplay)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isShowingEditTripSheet.toggle()
                } label: {
                    Image(systemName: "pencil").contentShape(Rectangle())
                }
                .disabled(viewModel.isDeleted || viewModel.isLoading)
                .sheet(isPresented: $isShowingEditTripSheet) {
                    EditTripView(viewModel: ViewModelFactory.getEditTripViewModel(tripViewModel: viewModel))
                }

                Button {
                    isShowingInviteUsersSheet.toggle()
                } label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                }
                .disabled(viewModel.isDeleted || viewModel.isLoading)
                .sheet(isPresented: $isShowingInviteUsersSheet) {
                    InviteUserView(viewModel: ViewModelFactory.copyTripViewModel(tripViewModel: viewModel))
                }

                Button {
                    isShowingAddPlanSheet.toggle()
                } label: {
                    Image(systemName: "note.text.badge.plus")
                }
                .disabled(viewModel.isDeleted || viewModel.isLoading)
                .sheet(isPresented: $isShowingAddPlanSheet) {
                    AddPlanView(viewModel: ViewModelFactory.getAddPlanViewModel(tripViewModel: viewModel))
                }
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
