//
//  ExpandableTextView.swift
//  TourMate
//
//  Created by Terence Ho on 15/4/22.
//

import SwiftUI

struct ExpandableTextView: View {

    @State private var isExpanded = false
    let content: String
    let allowedLineLimit: Int
    let font: Font

    init(content: String, allowedLineLimit: Int = 3, font: Font = .body) {
        self.content = content
        self.allowedLineLimit = allowedLineLimit
        self.font = font
    }

    var lineLimit: Int? {
        if isExpanded {
            return nil
        }
        return allowedLineLimit
    }

    var expansionText: String {
        if isExpanded {
            return "Less"
        }
        return "More"
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 5.0) {
            Text(content)
                .font(font)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(lineLimit)

            Button {
                isExpanded.toggle()
            } label: {
                Text(isExpanded ? "Less" : "More")
                    .font(.caption).bold()
                    .padding([.horizontal])
                    .background(Color.primary.colorInvert())
            }
        }
    }
}

// struct ExpandableTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpandableTextView()
//    }
// }
