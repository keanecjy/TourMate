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
    let creationDate: Date

    // Did not include Timezone
    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm a"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            HStack(alignment: .top, spacing: 5.0) {
                Text(name)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Text(getDateString(creationDate))
            }

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
