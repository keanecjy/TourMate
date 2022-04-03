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

    var body: some View {
        let region = Binding<MKCoordinateRegion>(
            get: {
                let center = CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude)
                return MKCoordinateRegion(center: center, latitudinalMeters: 750, longitudinalMeters: 750)
            },
            set: { _ in }
        )
        HStack(alignment: .top) {
            Image(systemName: "location.fill")
                .font(.title)
            VStack(alignment: .leading) {
                Text(location.addressLineOne)
                Text(location.addressLineTwo)
                Map(coordinateRegion: region, annotationItems: [location]) {
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
                }
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
