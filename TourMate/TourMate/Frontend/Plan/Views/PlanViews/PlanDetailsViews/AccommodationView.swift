//
//  AccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct AccommodationView: View {
    @StateObject var accommodationViewModel: PlanViewModel<Accommodation>
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = accommodationViewModel.plan.startDateTime.timeZone
        return dateFormatter.string(from: date)
    }

    var body: some View {
        if accommodationViewModel.hasError {
            Text("Error occurred")
        } else {
            HStack {
                if let accommodation = accommodationViewModel.plan {
                    VStack(alignment: .leading) {

                        HStack(spacing: 10.0) {
                            PlanStatusView(status: accommodation.status)
                                .padding()

                            if accommodation.status == .proposed {
                                UpvotePlanView(viewModel: accommodationViewModel)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("From")
                                .font(.caption)
                            Text(getDateString(accommodation.startDateTime.date))
                                .font(.headline)

                            Text("To")
                                .font(.caption)
                            Text(getDateString(accommodation.endDateTime.date))
                                .font(.headline)
                        }
                        .padding()

                        // Address
                        VStack(alignment: .leading) {
                            Text("Address")
                                .font(.caption)
                            Text(accommodation.startLocation?.addressFull ?? "")
                        }
                        .padding()

                        // Phone number
                        if let phone = accommodation.phone {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text(phone)
                            }
                            .padding()
                        }

                        // Website
                        if let website = accommodation.website {
                            HStack {
                                Image(systemName: "globe.americas.fill")
                                Text(website)
                            }
                            .padding()
                        }

                        CommentsView(commentsViewModel: accommodationViewModel.commentsViewModel)
                            .padding()

                        Spacer()
                    }

                    Spacer()
                }
            }
            .navigationBarTitle(accommodationViewModel.plan.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditAccommodationView(viewModel: accommodationViewModel)
                    }
                }
            }
            .task {
                await accommodationViewModel.fetchPlanAndListen()
            }
            .onReceive(accommodationViewModel.objectWillChange) {
                if accommodationViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in accommodationViewModel.detachListener() })
        }
    }
}

// struct AccommodationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccommodationView()
//    }
// }
