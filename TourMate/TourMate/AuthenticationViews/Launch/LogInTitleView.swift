//
//  LogInTitleView.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct LogInTitleView: View {
    var maxWidth: Double

    var body: some View {
        Group {
            Text("Log In")
            .font(.title2)
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: maxWidth)
        .background(.blue)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 5.0, x: 3.0, y: 4.0)
        .padding()
    }
}

struct LogInTitleView_Previews: PreviewProvider {
    static var previews: some View {
        LogInTitleView(maxWidth: 100.0)
    }
}
