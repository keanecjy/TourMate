//
//  AccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import SwiftUI

struct AccommodationView: View {
    @StateObject var planViewModel: AccommodationViewModel

    var body: some View {
        PlanView(planViewModel: planViewModel) {
            LocationView(startLocation: planViewModel.location)
        }
    }
}
