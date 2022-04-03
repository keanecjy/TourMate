//
//  PlanBoxView.swift
//  TourMate
//
//  Created by Rayner Lim on 29/3/22.
//
import SwiftUI

struct PlanBoxView: View {
    let title: String
    let startDate: Date
    let endDate: Date?
    let dateFormatter: DateFormatter
    let status: PlanStatus

    init(title: String, startDate: Date, endDate: Date? = nil, timeZone: TimeZone, status: PlanStatus) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeStyle = .short
        self.dateFormatter.timeZone = timeZone
        self.status = status
    }

    var startTimeString: String {
        dateFormatter.string(from: startDate)
    }

    var endTimeString: String? {
        guard let endDate = endDate else {
            return nil
        }
        return dateFormatter.string(from: endDate)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.headline)
                PlanStatusView(status: status)
                    .padding([.horizontal])
            }
            HStack(spacing: 0) {
                Text(startTimeString)
                    .font(.caption)
                if let endTimeString = endTimeString {
                    Text(" - " + endTimeString)
                        .font(.caption)
                }
            }
        }
        .padding()
    }
}

struct PlanBoxView_Previews: PreviewProvider {
    static var previews: some View {
        PlanBoxView(title: "Visit Venice Beach",
                     startDate: Date(timeIntervalSince1970: 1_651_442_400),
                     endDate: Date(timeIntervalSince1970: 1_651_453_200),
                     timeZone: TimeZone(abbreviation: "PST")!,
                     status: .confirmed)
    }
}
