//
//  AttendeesView.swift
//  TourMate
//
//  Created by Terence Ho on 25/3/22.
//

import SwiftUI

struct AttendeesView: View {
    @ObservedObject var viewModel: TripViewModel

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(viewModel.attendees, id: \.id) { user in
                    UserIconView(imageUrl: user.imageUrl, name: user.name)
                }

                Spacer()
            }
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchAttendees()
            }
        }
    }
}

// struct AttendeesView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttendeesView()
//    }
// }
