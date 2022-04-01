//
//  PlanFormView.swift
//  TourMate
//
//  Created by Terence Ho on 1/4/22.
//

import SwiftUI

struct PlanFormView: View {

    @State var isShowingSearchStartLocSheet: Bool = false
    @State var isShowingSearchEndLocSheet: Bool = false
    @ObservedObject var viewModel: PlanFormViewModel

    var body: some View {
        Form {
            ConfirmedToggle(status: $viewModel.planStatus)

            TextField("Event Name", text: $viewModel.planName)

            DatePicker("Start Date",
                       selection: $viewModel.planStartDate,
                       in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                       displayedComponents: [.date, .hourAndMinute])

            DatePicker("End Date",
                       selection: $viewModel.planEndDate,
                       in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                       displayedComponents: [.date, .hourAndMinute])

            TextField("Start Location", text: $viewModel.planStartLocation)
                .sheet(isPresented: $isShowingSearchStartLocSheet) {
                    SearchView(viewModel: SearchViewModel(), planAddress: $viewModel.planStartLocation)
                }
                .onTapGesture {
                    isShowingSearchStartLocSheet.toggle()
                }

            TextField("End Location", text: $viewModel.planEndLocation)
                .sheet(isPresented: $isShowingSearchEndLocSheet) {
                    SearchView(viewModel: SearchViewModel(), planAddress: $viewModel.planEndLocation)
                }
                .onTapGesture {
                    isShowingSearchEndLocSheet.toggle()
                }

            // TODO: Add Additional Info box
        }
    }
}

// struct PlanFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanFormView()
//    }
// }
