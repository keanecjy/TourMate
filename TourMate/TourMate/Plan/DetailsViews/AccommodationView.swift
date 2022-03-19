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

    func getDateString(_ date: Date) -> String {
        guard let accommodation = accommodationViewModel.plan else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = accommodation.startTimeZone
        return dateFormatter.string(from: date)
    }

    var body: some View {
        HStack {
            if let accommodation = accommodationViewModel.plan {
                VStack(alignment: .leading) {
                    // Start time
                    VStack(alignment: .leading) {
                        Text("From")
                            .font(.caption)
                        Text(getDateString(accommodation.startDate))
                            .font(.headline)

                        if let endDate = accommodation.endDate {
                            Text("To")
                                .font(.caption)
                            Text(getDateString(endDate))
                                .font(.headline)
                        }
                    }
                    .padding()

                    // Address
                    if let address = accommodation.address {
                        VStack(alignment: .leading) {
                            Text("Address")
                                .font(.caption)
                            Text(address)
                        }
                        .padding()
                    }

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
                    Text("Present Restaurant Edit View")
                }
            }
        }
        .task {
            await accommodationViewModel.fetchPlan()
        }
    }
}

// struct AccommodationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccommodationView()
//    }
// }
