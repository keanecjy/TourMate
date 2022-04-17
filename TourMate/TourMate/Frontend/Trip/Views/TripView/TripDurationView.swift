//
//  TripDurationView.swift
//  TourMate
//
//  Created by Keane Chan on 17/4/22.
//

import SwiftUI

struct TripDurationView: View {
    let durationDisplay: String

    var body: some View {
        Text(durationDisplay)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal])
    }
}
