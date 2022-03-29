//
//  SearchView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SearchViewModel
    @Binding var planAddress: String

    var searchTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Enter Location", text: $viewModel.query)
        }
        .padding()
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("SUGGESTIONS").font(.caption)
                List(viewModel.suggestedLocations, id: \.addressFull) { suggestion in
                    Text(suggestion.addressFull)
                        .onTapGesture {
                            planAddress = suggestion.addressFull
                            dismiss()
                        }
                }
            }
            .padding(.leading)
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    searchTextField
                }
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// struct AutocompleteTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            SearchView()
//                .previewDevice("iPad (9th generation)")
//        }
//    }
// }
