//
//  SubmitButton.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct AuthPageSubmitButton: View {
    var onPress: () async -> Void
    var title: String
    var maxWidth: Double
    var isDisabled: Bool

    var color: Color {
        if isDisabled {
            return .gray
        } else {
            return .blue
        }
    }

    var body: some View {
        Button {
            Task {
                await onPress()
            }
        } label: {
            Text(title)
            .font(.title2)
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: maxWidth)
        .background(color)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 5.0, x: 3.0, y: 4.0)
        .padding()
        .disabled(isDisabled)
    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthPageSubmitButton(onPress: {}, title: "Log In", maxWidth: 100.0, isDisabled: false)
    }
}
