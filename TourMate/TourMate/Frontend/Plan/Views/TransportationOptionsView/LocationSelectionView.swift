//
//  LocationSelectionView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import SwiftUI

struct LocationSelectionView: View {
    @Environment(\.dismiss) var dismiss

    let title: String
    @Binding var location: Location
    let viewModel: LocationSelectionViewModel

    init(_ title: String, location: Binding<Location>, viewModel: LocationSelectionViewModel) {
        self.title = title
        self._location = location
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List(viewModel.locations) { location in
                Text(location.addressFull)
                    .onTapGesture {
                        self.location = location
                        dismiss()
                    }
            }
            .listStyle(.plain)
            .navigationTitle(title)
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
