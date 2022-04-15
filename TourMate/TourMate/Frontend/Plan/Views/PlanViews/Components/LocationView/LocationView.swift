//
//  LocationView.swift
//  TourMate
//
//  Created by Keane Chan on 7/4/22.
//

import SwiftUI

struct LocationView: View {
    let startLocation: Location?
    let endLocation: Location?

    internal init(startLocation: Location?, endLocation: Location? = nil) {
        self.startLocation = startLocation
        self.endLocation = endLocation
    }

    var body: some View {
        if let location = startLocation,
           location.isPresent() {
            MapView(startLocation: location,
                    endLocation: endLocation)
        } else if let location = endLocation,
                  location.isPresent() {
            MapView(startLocation: location,
                    endLocation: nil)
        } else {
            HStack(alignment: .top) {
                Image(systemName: "location.fill")
                    .font(.title)
                Text("No location provided")
            }
        }
    }
}
