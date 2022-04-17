//
//  SuggestionButton.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import SwiftUI

struct SuggestionButton: View {
    let title: String
    let subtitle: String
    let iconName: String
    let action: () -> Void

    init(title: String, subtitle: String,
         iconName: String = "exclamationmark.bubble.fill",
         action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                Text(subtitle)
                    .foregroundColor(.gray)

            }
            .font(.caption)
            .prefixedWithIcon(named: iconName)
            .padding(7)
            .foregroundColor(.black)
            .overlay(RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary.opacity(0.25)))
        }
    }
}

struct SuggestionButton_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionButton(
            title: "Travel Plans",
            subtitle: "Timely information about your itinerary",
            iconName: "exclamationmark.bubble.fill") {
                print("pressed")
        }
    }
}
