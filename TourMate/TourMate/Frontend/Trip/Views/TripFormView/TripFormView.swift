//
//  TripFormView.swift
//  TourMate
//
//  Created by Terence Ho on 31/3/22.
//

import SwiftUI

struct TripFormView: View {

    @ObservedObject var viewModel: TripFormViewModel

    var body: some View {
        Form {
            TextField("Trip Name*", text: $viewModel.tripName)

            AddressTextField(title: "Destination city*", location: $viewModel.tripLocation)

            DatePicker(
                "Start Date",
                selection: $viewModel.tripStartDate,
                in: Date()...,
                displayedComponents: [.date]
            )

            DatePicker(
                "End Date",
                selection: $viewModel.tripEndDate,
                in: viewModel.fromStartDate,
                displayedComponents: [.date]
            )

            TextField("Image URL", text: $viewModel.tripImageURL)
        }
    }
}

// struct TripFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripFormView()
//    }
// }
