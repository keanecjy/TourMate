//
//  PlanStatusView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct PlanStatusView: View {
    let status: PlanStatus

    var backgroundColor: Color {
        if status == .confirmed {
            return .green
        } else {
            return .red
        }
    }

    var statusText: String {
        status.rawValue.capitalized
    }

    var body: some View {
        Text(statusText)
            .font(.caption)
            .padding(5.0)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(20.0)
    }
}

// struct PlanStatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanStatusView()
//    }
// }
