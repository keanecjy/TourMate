//
//  AttendeesView.swift
//  TourMate
//
//  Created by Terence Ho on 25/3/22.
//

import SwiftUI

struct AttendeesView: View {

    // The VM binds to Database. Will not need to fetch
    @ObservedObject var viewModel: TripViewModel

    var body: some View {
        VStack {
            Text("Attendees")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom, .horizontal])

            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.attendees, id: \.id) { user in
                        UserIconView(imageUrl: user.imageUrl, name: user.name)
                    }

                    Spacer()
                }
            }
            .padding()
        }
    }
}

// struct AttendeesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendeesView()
//    }
// }
