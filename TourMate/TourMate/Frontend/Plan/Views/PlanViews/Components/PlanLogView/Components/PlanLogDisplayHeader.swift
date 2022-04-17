//
//  PlanLogVersionHeader.swift
//  TourMate
//
//  Created by Terence Ho on 16/4/22.
//

import SwiftUI

struct PlanLogDisplayHeader: View {

    let header: String
    let planDiffMap: PlanDiffMap

    var body: some View {
        HStack {
            Spacer()

            VStack(spacing: 5.0) {
                Text(header)
                    .bold()

                PlanDiffTextView(planDiffMap: planDiffMap)
            }

            Spacer()
        }
    }
}

// struct PlanLogVersionHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanLogVersionHeader()
//    }
// }
