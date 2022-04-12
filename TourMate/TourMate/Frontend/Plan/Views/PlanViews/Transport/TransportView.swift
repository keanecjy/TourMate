//
//  TransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct TransportView: View {
    @StateObject var planViewModel: TransportViewModel

    var body: some View {
        PlanView(planViewModel: planViewModel) {
            LocationView(startLocation: planViewModel.startLocation,
                         endLocation: planViewModel.endLocation)
        }
    }
}
