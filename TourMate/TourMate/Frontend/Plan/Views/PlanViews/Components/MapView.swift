//
//  MapView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 26/3/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    let location: Location
    @State private var region: MKCoordinateRegion

    init(location: Location) {
        self.location = location
        self.region = MKCoordinateRegion()
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
            span: MKCoordinateSpan())
    }

        var body: some View {
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
