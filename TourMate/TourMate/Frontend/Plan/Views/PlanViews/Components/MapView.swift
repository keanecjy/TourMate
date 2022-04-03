//
//  MapView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 26/3/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    let startLocation: Location
    let endLocation: Location?

    var body: some View {
        let region = Binding<MKCoordinateRegion>(
            get: {
                let center = CLLocationCoordinate2D(
                    latitude: startLocation.latitude,
                    longitude: startLocation.longitude)
                return MKCoordinateRegion(center: center, latitudinalMeters: 750, longitudinalMeters: 750)
            },
            set: { _ in }
        )

        if let endLocation = endLocation {
            HStack(alignment: .top) {
                Image(systemName: "location.fill")
                    .font(.title)
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Start Location").font(.caption)
                            Text(startLocation.addressLineOne)
                            Text(startLocation.addressLineTwo)
                        }
                        VStack(alignment: .leading) {
                            Text("End Location").font(.caption)
                            Text(endLocation.addressLineOne)
                            Text(endLocation.addressLineTwo)
                        }
                    }
                    Map(coordinateRegion: region, annotationItems: [startLocation, endLocation]) {
                        MapMarker(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
                    }
                    .cornerRadius(15)
                }
            }
        } else {
            HStack(alignment: .top) {
                Image(systemName: "location.fill")
                    .font(.title)
                VStack(alignment: .leading) {
                    Text("Location").font(.caption)
                    Text(startLocation.addressLineOne)
                    Text(startLocation.addressLineTwo)
                    Map(coordinateRegion: region, annotationItems: [startLocation]) {
                        MapMarker(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
                    }
                    .cornerRadius(15)
                }
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
//            longitude: 103.776_4, latitude: 1.296_6)
//        return MapView(startLocation: location, endLocation: nil)
//    }
// }
