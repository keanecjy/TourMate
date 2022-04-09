//
//  PlanFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

@MainActor
struct AddPlanView: View {
    @Environment(\.dismiss) var dismiss

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
                    HStack {
                        Image(systemName: "figure.walk.circle.fill")
                        Text("Activity")
                    }
                }
                .sheet(isPresented: $isShowingAddActivitySheet) {
                    AddActivityView(viewModel: viewModelFactory.getAddActivityViewModel(trip: trip))
                }

                Button {
                    isShowingAddAccommodationSheet.toggle()
                } label: {
                    HStack {
                        Image(systemName: "bed.double.circle.fill")
                        Text("Accommodation")
                    }
                }

                Button {
                    isShowingAddTransportSheet.toggle()
                } label: {
                    HStack {
                        Image(systemName: "car.circle.fill")
                        Text("Transport")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Add a Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
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
