//
//  TransportationOptionsView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 15/4/22.
//

import SwiftUI

struct TransportationOptionsView: View {
    @State var fromLocation = Location()
    @State var toLocation = Location()
    @StateObject var fromSearchViewModel: SearchViewModel = ViewModelFactory().getSearchViewModel()
    @StateObject var toSearchViewModel: SearchViewModel = ViewModelFactory().getSearchViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                AddressTextField(title: "From", location: $fromLocation, viewModel: fromSearchViewModel, query: $fromSearchViewModel.locationQuery)
                AddressTextField(title: "To", location: $toLocation, viewModel: toSearchViewModel, query: $toSearchViewModel.locationQuery)
                Text("No results found.")
                Spacer()
            }
            .navigationTitle("Transportation Options")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct TransportationOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransportationOptionsView()
    }
}
