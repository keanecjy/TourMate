//
//  LocationHeaderView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct LocationHeaderView: View {
    let startLocation: Location?
    let endLocation: Location?

    var body: some View {
        if let startLocation = startLocation, let endLocation = endLocation {
            HStack {
                LocationTextView(header: "Start Location", location: startLocation)
                LocationTextView(header: "End Location", location: endLocation)
            }
        } else if let startLocation = startLocation {
            LocationTextView(header: "Location", location: startLocation)
        } else {
            Text("No Location Provided").font(.body).bold()
        }
    }
}
