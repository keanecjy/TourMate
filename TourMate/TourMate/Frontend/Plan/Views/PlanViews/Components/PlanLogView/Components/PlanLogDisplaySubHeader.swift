//
//  PlanLogDisplaySubHeader.swift
//  TourMate
//
//  Created by Terence Ho on 16/4/22.
//

import SwiftUI

struct PlanLogDisplaySubHeader: View {
    let subHeader: String

    var body: some View {
        HStack {
            Spacer()

            Text(subHeader)

            Spacer()
        }
    }
}

// struct PlanLogDisplaySubHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanLogDisplaySubHeader()
//    }
// }
