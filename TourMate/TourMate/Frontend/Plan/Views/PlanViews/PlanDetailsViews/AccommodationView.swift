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
        guard let accommodation = accommodationViewModel.plan else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = accommodation.startDateTime.timeZone
        return dateFormatter.string(from: date)
    }

    var body: some View {
        if accommodationViewModel.hasError {
            Text("Error occurred")
        } else {
            HStack {
                if let accommodation = accommodationViewModel.plan {
                    VStack(alignment: .leading) {
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
                            Text(accommodation.startLocation)
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

                        Spacer()
                    }

                    Spacer()
                }
            }
            .navigationBarTitle(accommodationViewModel.plan?.name ?? "Accommodation")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        // Edit Plan
                        // After edit -> fetch Plan
                        // If nothing is fetched -> dismiss this view

                        // on dismiss
                        Task {
                            await accommodationViewModel.fetchPlan()

                            // TODO: UI Fix
                            // There is a lag between setting the plan to nil
                            // And when we dismiss this view
                            // Maybe need to see how to change the logic
                            if accommodationViewModel.plan == nil {
                                dismiss()
                            }
                        }
                    } content: {
                        if let accommodation = accommodationViewModel.plan {
                            EditAccommodationView(accommodation: accommodation)
                        } else {
                            Text("Error")
                        }
                    }
                }
            }
            .task {
                await accommodationViewModel.fetchPlan()
            }
        }
    }
}

// struct AccommodationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccommodationView()
//    }
// }
