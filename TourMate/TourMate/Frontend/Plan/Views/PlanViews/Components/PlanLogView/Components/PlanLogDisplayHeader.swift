//
//  PlanLogVersionHeader.swift
//  TourMate
//
//  Created by Terence Ho on 16/4/22.
//

import SwiftUI

struct PlanLogDisplayHeader: View {

    let header: String

    var body: some View {
        HStack {
            Spacer()

            Text(header)
                .bold()

            Spacer()
        }
    }
}

// struct PlanLogVersionHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanLogVersionHeader()
//    }
// }
