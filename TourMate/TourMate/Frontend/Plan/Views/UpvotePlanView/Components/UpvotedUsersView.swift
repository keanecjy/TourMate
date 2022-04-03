//
//  UpvotedUsersView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct UpvotedUsersView: View {

    var upvotedUsers: [User]
    let displayName: Bool

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(upvotedUsers, id: \.id) { user in
                    UserIconView(imageUrl: user.imageUrl, name: user.name, displayName: displayName)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding()
    }
}

// struct UpvotedUsersView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpvotedUsersView()
//    }
// }
