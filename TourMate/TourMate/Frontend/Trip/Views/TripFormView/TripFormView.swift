//
//  TripFormView.swift
//  TourMate
//
//  Created by Terence Ho on 31/3/22.
//

import SwiftUI

struct TripFormView<ViewModel>: View where ViewModel: TripFormViewModel {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Form {
            TextField("Trip Name*", text: $viewModel.trip.name)

            DatePicker(
                "Start Date",
                selection: $viewModel.trip.startDateTime.date,
                in: Date()...,
                displayedComponents: [.date]
            )

            DatePicker(
                "End Date",
                selection: $viewModel.trip.endDateTime.date,
                in: viewModel.fromStartDate,
                displayedComponents: [.date]
            )

            TextField("Image URL", text: $viewModel.trip.imageUrl ?? "")
        }
    }
}

// struct TripFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripFormView()
//    }
// }
