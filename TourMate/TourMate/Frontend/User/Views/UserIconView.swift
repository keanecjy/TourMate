//
//  UserIconView.swift
//  TourMate
//
//  Created by Terence Ho on 25/3/22.
//

import SwiftUI

struct UserIconView: View {

    let imageUrl: String
    let name: String
    let imageHeight = 50.0

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .clipped()
                    .frame(height: imageHeight, alignment: .center)

            } placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .clipped()
                    .frame(height: imageHeight, alignment: .center)
            }

            Text(name)
        }
    }
}

struct UserIconView_Previews: PreviewProvider {
    static var previews: some View {
        UserIconView(imageUrl: "https://cdn.pixabay.com/photo/2020/03/31/19/20/dog-4988985__340.jpg", name: "Username")
    }
}
