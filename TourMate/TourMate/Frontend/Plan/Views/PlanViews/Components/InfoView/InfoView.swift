//
//  InfoView.swift
//  TourMate
//
//  Created by Keane Chan on 7/4/22.
//

import SwiftUI

struct InfoView: View {
    @State private var isShowingAdditionalInfoSheet = false

    let additionalInfo: String

    var body: some View {
        HStack {
            Image(systemName: "newspaper")
                .font(.title)

            Button {
                isShowingAdditionalInfoSheet.toggle()
            } label: {
                Text("Additional Notes")
            }
            .sheet(isPresented: $isShowingAdditionalInfoSheet) {
                AdditionalInfoView(additionalInfo: additionalInfo)
            }
        }

    }
}
