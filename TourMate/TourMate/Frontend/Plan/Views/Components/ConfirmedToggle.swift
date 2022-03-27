//
//  ConfirmedToggle.swift
//  TourMate
//
//  Created by Tan Rui Quan on 26/3/22.
//

import SwiftUI

struct ConfirmedToggle: View {
    @Binding var status: PlanStatus

    var body: some View {
        Toggle("Confirmed?", isOn: Binding<Bool>(
            get: { status == PlanStatus.confirmed },
            set: { select in
                if select {
                    status = PlanStatus.confirmed
                } else {
                    status = PlanStatus.proposed
                }
            })
        )
    }
}

// struct ConfirmedToggle_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmedToggle()
//    }
// }
