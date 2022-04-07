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

    var body: some View {
        if let location = startLocation {
            MapView(startLocation: location,
                    endLocation: endLocation)
        } else {
            HStack(alignment: .top) {
                Image(systemName: "location.fill")
                    .font(.title)
                Text("No location provided")
            }
        }
    }
}
