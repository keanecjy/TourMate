//
//  AddressTextField.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import SwiftUI

struct AddressTextField: View {
    let title: String
    @Binding var text: String
    @State var isShowingSearchSheet = false

    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    var body: some View {
        TextField(title, text: $text)
            .disabled(true)
            .sheet(isPresented: $isShowingSearchSheet) {
                SearchView(viewModel: SearchViewModel(), planAddress: $text)
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
