//
//  CommentIconView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentIconView: View {
    @ObservedObject var commentViewModel: CommentViewModel
    let imageHeight = 50.0

    var body: some View {
        AsyncImage(url: URL(string: commentViewModel.user.imageUrl)) { image in
            image
                .resizable()
                .clipShape(Circle())
                .frame(width: imageHeight, height: imageHeight, alignment: .center)
        } placeholder: {
            Image(systemName: "person.fill")
                .resizable()
                .clipShape(Circle())
                .frame(width: imageHeight, height: imageHeight, alignment: .center)
        }
    }
}

// struct CommentIconView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentIconView()
//    }
// }
