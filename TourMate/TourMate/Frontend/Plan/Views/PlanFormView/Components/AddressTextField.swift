//
//  AddressTextField.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import SwiftUI

@MainActor
struct AddressTextField: View {
    let title: String
    @Binding var location: Location
    @State var isShowingSearchSheet = false
    @ObservedObject var viewModel: SearchViewModel
    @Binding var query: String

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        TextField(title, text: $location.addressFull)
            .sheet(isPresented: $isShowingSearchSheet) {
                SearchView(viewModel: viewModel, location: $location) {
                    TextField("Enter Location", text: $query)
                        .prefixedWithIcon(named: "magnifyingglass")
                        .padding()
                        .textFieldStyle(.roundedBorder)
                }
            }
            .onTapGesture {
                isShowingSearchSheet.toggle()
            }
    }
}

// struct AddressTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        AddressTextField()
//    }
// }
