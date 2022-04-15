//
//  LocationTextView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct LocationTextView: View {
    var header: String
    var location: Location

    var body: some View {
        VStack(alignment: .leading) {
            Text(header).font(.body).bold()
            Text(location.addressLineOne)
            Text(location.addressLineTwo)
        }
    }
}
