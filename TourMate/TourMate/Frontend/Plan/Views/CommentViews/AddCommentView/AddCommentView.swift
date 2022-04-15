//
//  AddCommentView.swift
//  TourMate
//
//  Created by Terence Ho on 14/4/22.
//

import SwiftUI

struct AddCommentView: View {
    @StateObject var viewModel: AddCommentViewModel

    var body: some View {
        HStack(alignment: .center) {
            TextField("Add a comment", text: $viewModel.commentField)
                .padding()
                .background(Color.primary.colorInvert())
                .cornerRadius(20.0)

            Button {
                Task {
                    await viewModel.addComment()
                }
            } label: {
                Image(systemName: "paperplane.fill")
            }
        }
    }
}

// struct AddCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCommentView()
//    }
// }
