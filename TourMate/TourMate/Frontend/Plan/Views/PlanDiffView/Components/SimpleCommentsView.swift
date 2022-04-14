//
//  SimpleCommentsView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct SimpleCommentsView: View {
    @StateObject var viewModel: CommentsViewModel

    var body: some View {
        if viewModel.hasError {
            Text("Error occured")
        } else {
            VStack(spacing: 10.0) {
                CommentListView(viewModel: viewModel)
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(20.0)
            .task {
                await viewModel.fetchVersionedCommentsAndListen()
            }
            .onDisappear(perform: { () in viewModel.detachListener() })
        }
    }
}
