//
//  AttendeesView.swift
//  TourMate
//
//  Created by Terence Ho on 25/3/22.
//

import SwiftUI

struct AttendeesView: View {

    let attendees: [User]

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(attendees, id: \.id) { user in
                        UserIconView(imageUrl: user.imageUrl, name: user.name)
                    }
                }
            }
        }
        .padding()
    }
}

// struct AttendeesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendeesView()
//    }
// }
