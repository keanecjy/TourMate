//
//  PlanWarningView.swift
//  TourMate
//
//  Created by Terence Ho on 17/4/22.
//

import SwiftUI

struct PlanWarningView<Content: View, ButtonLabel: View>: View {
    @State private var showPopover: Bool

    let content: Content
    let buttonLabel: ButtonLabel

    init(@ViewBuilder mainContent: () -> Content, @ViewBuilder buttonLabel: () -> ButtonLabel) {
        self._showPopover = State(wrappedValue: false)
        self.content = mainContent()
        self.buttonLabel = buttonLabel()
    }

    var body: some View {
        Button {
            showPopover.toggle()
        } label: {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")

                buttonLabel
            }
            .foregroundColor(.red)
        }
        .padding([.horizontal, .top])
        .popover(isPresented: $showPopover) {
            content
                .padding()
        }
    }
}

// struct PlanWarningView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanWarningView()
//    }
// }
