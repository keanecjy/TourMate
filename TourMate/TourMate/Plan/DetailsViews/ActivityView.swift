//
//  ActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct ActivityView: View {
    let activity: Activity

    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = activity.timeZone
        return dateFormatter.string(from: date)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    // Start Time
                    Text("From")
                        .font(.caption)
                    Text(getDateString(activity.startDate))
                        .font(.headline)

                    // End Time
                    if let endDate = activity.endDate {
                        Text("To")
                            .font(.caption)
                        Text(getDateString(endDate))
                            .font(.headline)
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    if let venue = activity.venue {
                        Text("Venue")
                            .font(.caption)
                        Text(venue)
                    }

                    if let address = activity.address {
                        Text("Address")
                            .font(.caption)
                        Text(address)
                    }
                }
                .padding()

                // Phone number
                if let phone = activity.phone {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(phone)
                    }
                    .padding()
                }

                // Website
                if let website = activity.website {
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
        .navigationBarTitle(activity.name)
    }
}

// struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView()
//    }
// }
