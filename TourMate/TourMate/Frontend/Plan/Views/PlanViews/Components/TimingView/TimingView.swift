//
//  TimingView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 1/4/22.
//

import SwiftUI

struct TimingView: View {
    let startDate: DateTime
    let endDate: DateTime
    let displayIcon: Bool

    @State private var dateFormatter = DateFormatter()

    init(startDate: DateTime, endDate: DateTime, displayIcon: Bool = true) {
        self.startDate = startDate
        self.endDate = endDate
        self.displayIcon = displayIcon
    }

    var body: some View {
        HStack(alignment: .top) {
            if displayIcon {
                Image(systemName: "clock")
                    .font(.title)
            }

            VStack(alignment: .leading) {
                Text("From").font(.body).bold()
                Text(startDate.date, formatter: dateFormatter)
                    .fixedSize(horizontal: false, vertical: true) // wrap if text is too long
            }

            VStack(alignment: .leading) {
                Text("To").font(.body).bold()
                Text(endDate.date, formatter: dateFormatter)
                    .fixedSize(horizontal: false, vertical: true) // wrap if text is too long
            }
        }
        .onAppear {
            // the date time doesn't show upon exit screen -> re-enter screen if it is not initialised again
            dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            dateFormatter.timeZone = startDate.timeZone // By default we take the start time zone
        }
    }
}
