//
//  AccommodationFormView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct AccommodationFormView: View {
    @ObservedObject var viewModel: PlanFormViewModel<Accommodation>
    @Binding var location: Location?

    var body: some View {
        PlanFormView(viewModel: viewModel,
                     startDateHeader: "Check-in Date",
                     endDateHeader: "Check-out Date") {

            Section("Location") {
                AddressTextField(title: "Address", location: $location)
            }
        }
    }
}
