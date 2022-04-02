//
//  MapView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 26/3/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var location: Location?
    @State private var region = MKCoordinateRegion()

        var body: some View {
            if let location = location {
                HStack(alignment: .top) {
                    Image(systemName: "location.fill")
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text(location.addressLineOne)
                        Text(location.addressLineTwo)
                        Map(coordinateRegion: $region, interactionModes: [])
                            .cornerRadius(15)
                    }
                }
                .onAppear {
                    region = MKCoordinateRegion()
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: location.latitude,
                                                       longitude: location.longitude),
                        latitudinalMeters: 750,
                        longitudinalMeters: 750
                    )
                }
            } else {
                HStack(alignment: .top) {
                    Image(systemName: "location.fill")
                        .font(.title)
                    Text("No location provided")
                }
            }
        }
}

// struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var location = Location(
//            addressLineOne: "NUS",
//            addressLineTwo: "National University of Singapore",
//            addressFull: "NUS, National University of Singapore",
//            longitude: 1.296_6, latitude: 103.776_4)
//        return MapView(location: location)
//    }
// }
