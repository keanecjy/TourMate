//
//  PlanFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

@MainActor
struct AddPlanView: View {
    @Environment(\.dismiss) var dismissPlanView

    let trip: Trip
    private let viewModelFactory = ViewModelFactory()

    @State private var isShowingAddActivitySheet = false
    @State private var isShowingAddAccommodationSheet = false
    @State private var isShowingAddTransportSheet = false

    var body: some View {
        NavigationView {
            List {
                Button {
                    isShowingAddActivitySheet.toggle()
                } label: {
                    Text("Activity")
                        .prefixedWithIcon(named: "figure.walk.circle.fill")
                }
                .sheet(isPresented: $isShowingAddActivitySheet) {
                    AddActivityView(viewModel: viewModelFactory.getAddActivityViewModel(trip: trip), dismissPlanView: dismissPlanView)
                }

                Button {
                    isShowingAddAccommodationSheet.toggle()
                } label: {
                    Text("Accommodation")
                        .prefixedWithIcon(named: "bed.double.circle.fill")
                }

                Button {
                    isShowingAddTransportSheet.toggle()
                } label: {
                    Text("Transport")
                        .prefixedWithIcon(named: "car.circle.fill")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Add a Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismissPlanView()
                    }
                }
            }
        }
    }
}

// struct PlanFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanFormView()
//    }
// }
