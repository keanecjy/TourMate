//
//  UpvoteButton.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct UpvoteButton: View {
    var hasUpvoted: Bool
    var action: () async -> Void

    var color: Color = .cyan

    var imageName: String {
        if hasUpvoted {
            return "hand.thumbsup.fill"
        } else {
            return "hand.thumbsup"
        }
    }

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Image(systemName: imageName)
                .foregroundColor(.cyan)
        }
    }
}

// struct UpvoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpvoteView()
//    }
// }
