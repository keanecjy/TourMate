//
//  ScrollableContentView.swift
//  TourMate
//
//  Created by Terence Ho on 16/4/22.
//

import SwiftUI

struct ActionableContentView<Content: View, ActionContent: View>: View {

    let content: Content
    let actionContent: ActionContent

    init(@ViewBuilder content: () -> Content, @ViewBuilder actionContent: () -> ActionContent) {
        self.content = content()
        self.actionContent = actionContent()
    }

    var body: some View {
        VStack(spacing: 15.0) {
            content

            actionContent
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20.0)
    }
}

// struct ScrollableContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollableContentView()
//    }
// }
