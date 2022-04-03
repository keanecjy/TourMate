//
//  TripCard.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripCard: View {
    let title: String
    let subtitle: String
    let imageUrl: String

    var body: some View {
        ZStack(alignment: .bottom) {
            TripImage(imageUrl: imageUrl, width: UIScreen.screenWidth - 20)
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .foregroundColor(.primary)
            .background(Color.primary
                            .colorInvert()
                            .opacity(0.75))
        }
        .contentShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .padding([.horizontal])
    }
}

struct TripCard_Previews: PreviewProvider {
    static var previews: some View {
        let view = TripCard(title: "West Coast Summer",
                            subtitle: "Sun, 1 May - Sat, 30 May",
                            imageUrl: "https://source.unsplash.com/qxstzQ__HMk")
        ForEach(ColorScheme.allCases, id: \.self, content: view.preferredColorScheme)
    }
}
