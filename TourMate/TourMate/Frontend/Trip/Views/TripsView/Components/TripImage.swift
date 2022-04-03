//
//  TripImage.swift
//  TourMate
//
//  Created by Keane Chan on 2/4/22.
//

import SwiftUI

struct TripImage: View {
    let defaultImageUrl: String = "https://pixabay.com/get/g3e6e2375c76aff949b9c58dc915b9fcab8c2292a070eed77ca9b40cadb3a56986e14b56f67c9258b4b29e14c2db266b55d7d60bed8b093c316718778e88b03de7a56a0d4b093f13b3a51fe464b4565cc_1920.jpg"

    let imageUrl: String

    init(imageUrl: String) {
        self.imageUrl = imageUrl.isEmpty ? defaultImageUrl : imageUrl
    }

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(height: 200, alignment: .center)
                .clipped()
        } placeholder: {
            Color.gray
        }
    }
}
