//
//  ScrollableContentView.swift
//  TourMate
//
//  Created by Terence Ho on 16/4/22.
//

import SwiftUI

struct ScrollableContentView<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20.0) {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Push all items to leading
        }
        .frame(height: 500.0, alignment: .leading) // push VStack to leading
    }
}

// struct ScrollableContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollableContentView()
//    }
// }
