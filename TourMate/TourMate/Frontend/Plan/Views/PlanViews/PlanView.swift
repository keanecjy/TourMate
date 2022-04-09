//
//  PlanView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

// import SwiftUI
//
// struct PlanView<Content: View>: View {
//    let locationContent: Content
//    @StateObject var planViewModel: PlanViewModel
//    let commentsViewModel: CommentsViewModel
//    let planUpvoteViewModel: PlanUpvoteViewModel
//    @State private var isShowingEditPlanSheet = false
//
//    @Environment(\.dismiss) var dismiss
//
//    private let viewModelFactory = ViewModelFactory()
//
//    init(planViewModel: PlanViewModel, @ViewBuilder content: () -> Content) {
//        self.locationContent = content()
//        self._planViewModel = StateObject(wrappedValue: planViewModel)
//        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
//        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)
//    }
//
//    // TODO: Push to XXEditView level
//    func getEditPlanView() -> some View {
//        switch planViewModel.plan {
//        case _ as Activity:
//            return AnyView(EditActivityView(viewModel: viewModelFactory.getEditActivityViewModel(planViewModel: planViewModel)))
//        default:
//            preconditionFailure("Such plan do not exists")
//        }
//    }
//
//    var body: some View {
//        if planViewModel.hasError {
//            Text("Error occurred")
//        } else if planViewModel.isLoading {
//            ProgressView()
//        } else {
//            VStack(alignment: .leading, spacing: 30.0) {
//                // TODO: Show image
//
//                PlanHeaderView(planName: planViewModel.nameDisplay,
//                               planStatus: planViewModel.statusDisplay,
//                               planOwner: planViewModel.planOwner,
//                               creationDateDisplay: planViewModel.creationDateDisplay)
//
//                PlanUpvoteView(viewModel: planUpvoteViewModel)
//
//                TimingView(startDate: planViewModel.startDateTimeDisplay,
//                           endDate: planViewModel.endDateTimeDisplay)
//
//                locationContent
//
//                InfoView(additionalInfo: planViewModel.additionalInfoDisplay)
//
//                CommentsView(viewModel: commentsViewModel)
//
//                Spacer() // Push everything to the top
//            }
//            .padding()
//            .navigationBarTitle("") // Needed in order to display the nav back button. Best fix is to use .inline
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .primaryAction) {
//                    Button {
//                        isShowingEditPlanSheet.toggle()
//                    } label: {
//                        Image(systemName: "pencil")
//                    }
//                    .sheet(isPresented: $isShowingEditPlanSheet) {
//                        getEditPlanView()
//                    }
//                }
//            }
//            .task {
//                await planViewModel.fetchPlanAndListen()
//                await planViewModel.updatePlanOwner()
//            }
//            .onReceive(planViewModel.objectWillChange) {
//                if planViewModel.isDeleted {
//                    dismiss()
//                }
//            }
//            .onDisappear(perform: { () in planViewModel.detachListener() })
//        }
//    }
// }

// struct PlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView()
//    }
// }
