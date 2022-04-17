//
//  TransporationOptionsButton.swift
//  TourMate
//
//  Created by Keane Chan on 17/4/22.
//

import SwiftUI

struct TransporationOptionsButton: View {

    @ObservedObject var viewModel: PlansViewModel

    @State private var isShowingTransportationOptionsSheet = false

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        Button {
            isShowingTransportationOptionsSheet.toggle()
        } label: {
            Label("Transport", systemImage: "bus")
        }
        .sheet(isPresented: $isShowingTransportationOptionsSheet) {
            let viewModel = viewModelFactory.getTransportationOptionsViewModel(plans: viewModel.plans)
            TransportationOptionsView(viewModel: viewModel)
        }

    }
}
