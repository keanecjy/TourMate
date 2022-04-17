//
//  AddPlanSelectionButton.swift
//  TourMate
//
//  Created by Keane Chan on 17/4/22.
//

import SwiftUI

struct AddPlanSelectionButton: View {
    @State private var isShowingAddPlanSheet = false

    @ObservedObject var viewModel: TripViewModel

    var body: some View {
        Button {
            isShowingAddPlanSheet.toggle()
        } label: {
            Image(systemName: "note.text.badge.plus")
        }
        .disabled(viewModel.isDeleted || viewModel.isLoading)
        .sheet(isPresented: $isShowingAddPlanSheet) {
            AddPlanSelectionView(trip: viewModel.trip)
        }
    }
}
