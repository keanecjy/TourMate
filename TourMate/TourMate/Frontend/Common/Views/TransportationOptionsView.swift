//
//  TransportationOptionsView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 15/4/22.
//

import SwiftUI

struct TransportationOptionsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = TransportationOptionsViewModel(plans: [], routingService: MockRoutingService())

    var body: some View {
        NavigationView {
            VStack {
                TextFieldButton("From", text: "Select starting point")
                TextFieldButton("To", text: "Select destination")
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.suggestions.isEmpty {
                    VStack(spacing: 100) {
                        Button {
                            viewModel.addFromLocation()
                            print("Start location: \(viewModel.fromLocation)")
                            print("End location: \(viewModel.toLocation)")
                        } label: {
                            Text("Add From location")
                        }

                        Button {
                            viewModel.addToLocation()
                            print("Start location: \(viewModel.fromLocation)")
                            print("End location: \(viewModel.toLocation)")
                        } label: {
                            Text("Add To location")
                        }
                    }
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
