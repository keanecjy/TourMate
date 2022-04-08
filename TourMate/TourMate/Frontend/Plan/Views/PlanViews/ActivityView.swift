//
//  ActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var activityViewModel: ActivityViewModel

    var body: some View {
        PlanView(planViewModel: activityViewModel) {
            LocationView(startLocation: activityViewModel.location, endLocation: nil)
        }
    }
}

// struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView()
//    }
// }
