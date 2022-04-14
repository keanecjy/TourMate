//
//  TransportFormView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct TransportFormView: View {
    @ObservedObject var viewModel: PlanFormViewModel<Transport>
    @Binding var startLocation: Location?
    @Binding var endLocation: Location?

    var body: some View {
        PlanFormView(viewModel: viewModel,
                     startDateHeader: "Departure Date",
                     endDateHeader: "Arrival Date") {

            Section("Location") {
                AddressTextField(title: "Departure Location", location: $startLocation)
                AddressTextField(title: "Arrival Location", location: $endLocation)
            }
        }
    }
}
