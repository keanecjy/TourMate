//
//  EditPlanViewButton.swift
//  TourMate
//
//  Created by Keane Chan on 17/4/22.
//

import SwiftUI

struct EditPlanViewButton<T: Plan>: View {
    @ObservedObject var planViewModel: PlanViewModel<T>

    @State private var isShowingEditPlanSheet = false

    private let viewFactory = ViewFactory()

    var body: some View {
        Button {
            isShowingEditPlanSheet.toggle()
        } label: {
            Image(systemName: "pencil")
        }
        .sheet(isPresented: $isShowingEditPlanSheet) {
            viewFactory.getEditPlanView(planViewModel: planViewModel)
        }
    }
}
