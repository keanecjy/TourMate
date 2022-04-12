//
//  ActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var planViewModel: ActivityViewModel

    var body: some View {
        PlanView(planViewModel: planViewModel) {
            LocationView(startLocation: planViewModel.location)
        }
    }
}
