//
//  NearbyPlacesView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import SwiftUI

struct NearbyPlacesView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: NearbyPlacesViewModel

    private func makeNearbyPlacesCellView(_ place: NearbyPlace) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(place.name).font(.title2).bold()
                Text(place.location.addressFull).font(.callout).foregroundColor(.gray)
            }

            Spacer()

            StarsView(rating: place.rating)
        }
    }

    var body: some View {
        NavigationView {
            List(viewModel.suggestions) { suggestion in
                makeNearbyPlacesCellView(suggestion)
            }
            .listStyle(.plain)
            .padding()
            .navigationTitle("Nearby places")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await viewModel.fetchNearbyPlaces()
        }
    }
}
