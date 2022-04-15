//
//  SearchView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import SwiftUI

struct SearchView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SearchViewModel
    @Binding var location: Location
    let searchTextField: Content

    init(viewModel: SearchViewModel,
         location: Binding<Location>,
         @ViewBuilder content: () -> Content) {
        self._dismiss = Environment(\.dismiss)
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._location = location
        self.searchTextField = content()
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("SUGGESTIONS").font(.caption)
                List(viewModel.suggestions) { suggestion in
                    Text(suggestion.addressFull)
                        .onTapGesture {
                            location = suggestion
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
