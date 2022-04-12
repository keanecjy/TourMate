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

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        TextField(title, text: $location.addressFull)
            .sheet(isPresented: $isShowingSearchSheet) {
                SearchView(viewModel: viewModelFactory.getSearchViewModel(), location: $location)
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
