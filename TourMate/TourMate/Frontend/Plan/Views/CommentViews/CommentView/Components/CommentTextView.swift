//
//  CommentTextView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentTextView: View {
    let name: String
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(name)
                .bold()
                .fixedSize(horizontal: false, vertical: true)

            Text(message)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// struct CommentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentTextView()
//    }
// }
