//
//  TextFieldButton.swift
//  TourMate
//
//  Created by Tan Rui Quan on 16/4/22.
//

import SwiftUI

struct TextFieldButton: View {
    let title: String
    let text: String
    let action: () -> Void

    init(_ title: String, text: String, action: @escaping () -> Void = { print("Press") }) {
        self.title = title
        self.text = text
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(text)
                Spacer()
            }
            .padding()
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke())
        }
    }
}
