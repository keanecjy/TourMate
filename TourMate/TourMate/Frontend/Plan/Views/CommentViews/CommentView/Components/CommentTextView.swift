//
//  CommentTextView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentTextView: View {
    @ObservedObject var commentViewModel: CommentViewModel

    @Environment(\.dismiss) var dismiss // not sure of effect

    // Did not include Timezone
    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm a"
        return dateFormatter.string(from: date)
    }

    var upvoteImageName: String {
        if commentViewModel.hasUpvotedComment {
            return "hand.thumbsup.fill"
        } else {
            return "hand.thumbsup"
        }
    }

    var body: some View {
        if commentViewModel.hasError {
            Text("Error occured")
        } else {
            VStack(alignment: .leading, spacing: 10.0) {
                HStack(alignment: .top, spacing: 5.0) {
                    Text(commentViewModel.user.name)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Text(getDateString(commentViewModel.comment.creationDate))
                }

                Text(commentViewModel.comment.message)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10.0) {
                    if commentViewModel.canEdit {
                        Text("Edit")
                            .foregroundColor(.blue)
                    }

                    Text("Like")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            Task {
                                await commentViewModel.upvoteComment()

                                if commentViewModel.isDeleted {
                                    dismiss()
                                }
                            }
                        }

                    if commentViewModel.upvoteCount > 0 {
                        HStack {
                            Image(systemName: upvoteImageName)
                                .foregroundColor(.blue)

                            Text(String(commentViewModel.upvoteCount))
                                .foregroundColor(.black)
                        }
                        .padding([.horizontal], 10.0)
                        .padding([.vertical], 4.0)
                        .background(.white)
                        .cornerRadius(20.0)
                    }
                }
                .disabled(commentViewModel.isLoading || commentViewModel.hasError)
            }
        }
    }
}

// struct CommentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentTextView()
//    }
// }
