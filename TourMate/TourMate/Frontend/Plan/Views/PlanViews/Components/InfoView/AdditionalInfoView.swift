//
//  AdditionalInfoView.swift
//  TourMate
//
//  Created by Terence Ho on 2/4/22.
//

import SwiftUI

struct AdditionalInfoView: View {

    let additionalInfo: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text("Additional Info")
                .bold()

            ExpandableTextView(content: additionalInfo)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// struct AdditionalInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdditionalInfoView()
//    }
// }
