//
//  MapView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 26/3/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var address = "1800 Ocean Front Walk, Venice, CA 90291, United States"
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900,
                                           longitude: -122.009_020),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )

        var body: some View {
            HStack {
                VStack {
                    Image(systemName: "location.fill")
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Text(address)
                    Map(coordinateRegion: $region, interactionModes: [])
                        .cornerRadius(15)
                }
            }
        }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
