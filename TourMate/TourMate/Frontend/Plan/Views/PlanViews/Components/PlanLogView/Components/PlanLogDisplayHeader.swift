//
//  PlanLogVersionHeader.swift
//  TourMate
//
//  Created by Terence Ho on 16/4/22.
//

import SwiftUI

struct PlanLogDisplayHeader: View {

    let header: String
    let subheader: String

    var body: some View {
        HStack {
            Spacer()

            VStack(spacing: 10.0) {
                Text(header)
                    .bold()

                Text(subheader)
                    .opacity(0.6)
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
