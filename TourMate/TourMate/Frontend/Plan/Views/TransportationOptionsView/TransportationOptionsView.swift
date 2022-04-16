//
//  TransportationOptionsView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 15/4/22.
//

import SwiftUI

struct TransportationOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: TransportationOptionsViewModel
    @State private var isShowingFromLocationSelectionSheet = false
    @State private var isShowingToLocationSelectionSheet = false

    var body: some View {
        NavigationView {
            VStack {
                TextFieldButton(
                    "From",
                    text: viewModel.fromLocation.isPresent()
                    ? viewModel.fromLocation.addressFull
                    : "Select starting point") {
                    isShowingFromLocationSelectionSheet.toggle()
                }
                .sheet(isPresented: $isShowingFromLocationSelectionSheet) {
                    LocationSelectionView(
                        "From",
                        location: $viewModel.fromLocation,
                        viewModel: LocationSelectionViewModel(plans: viewModel.plans))
                }

                TextFieldButton(
                    "To",
                    text: viewModel.toLocation.isPresent()
                    ? viewModel.toLocation.addressFull
                    : "Select destination") {
                    isShowingToLocationSelectionSheet.toggle()
                }
                .sheet(isPresented: $isShowingToLocationSelectionSheet) {
                    LocationSelectionView(
                        "To",
                        location: $viewModel.toLocation,
                        viewModel: LocationSelectionViewModel(plans: viewModel.plans))
                }

                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.suggestions.isEmpty {
                    Text("No results found")
                        .padding()
                } else {
                    List(viewModel.suggestions) { suggestion in
                        viewModel.makeTransportationOptionsCellView(suggestion)
                    }
                    .listStyle(.plain)
                }
                Spacer()
            }
            .padding([.horizontal])
            .navigationTitle("Transportation Options")
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
