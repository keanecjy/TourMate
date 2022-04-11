//
//  TransportFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import SwiftUI

struct TransportFormView: View {
    @ObservedObject var viewModel: TransportFormViewModel

    var body: some View {
        PlanFormView(viewModel: viewModel,
                     startDateHeader: "Departure Date",
                     endDateHeader: "Arrival Date") {
            Section("Location") {
                AddressTextField(title: "Departure Location", location: $viewModel.startLocation)
                AddressTextField(title: "Arrival Location", location: $viewModel.endLocation)
            }
        }
    }
}
