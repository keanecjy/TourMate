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
        HStack {
            ForEach(upvotedUsers, id: \.id) { user in
                UserIconView(imageUrl: user.imageUrl, name: user.name, displayName: displayName)
            }
        }
        .frame(minHeight: 54.0)
    }
}

// struct UpvotedUsersView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpvotedUsersView()
//    }
// }
