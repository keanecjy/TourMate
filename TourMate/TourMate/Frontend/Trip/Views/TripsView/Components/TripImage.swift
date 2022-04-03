//
//  TripImage.swift
//  TourMate
//
//  Created by Keane Chan on 2/4/22.
//

import SwiftUI

struct TripImage: View {
    let defaultImageUrl: String = "https://i.picsum.photos/id/902/800/200.jpg?hmac=NDBod84y3DFGEhECEEm0Um_1UQ9-jDO48d-_vodXKaY"

    let imageUrl: String
    let width: CGFloat
    let height: CGFloat

    init(imageUrl: String, width: CGFloat = UIScreen.screenWidth, height: CGFloat = 200) {
        self.imageUrl = imageUrl.isEmpty ? defaultImageUrl : imageUrl
        self.width = width
        self.height = height
    }

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height, alignment: .center)
                .clipped()
        } placeholder: {
            Color.gray
        }
    }
}
