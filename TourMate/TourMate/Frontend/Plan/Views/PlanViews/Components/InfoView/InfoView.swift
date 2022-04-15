//
//  InfoView.swift
//  TourMate
//
//  Created by Keane Chan on 7/4/22.
//

import SwiftUI

struct InfoView: View {

    let additionalInfo: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "newspaper")
                .font(.title)

            AdditionalInfoView(additionalInfo: additionalInfo)
        }
    }
}
