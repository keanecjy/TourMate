//
//  TransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct TransportView: View {
    let transport: Transport

    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = transport.timeZone
        return dateFormatter.string(from: date)
    }

    var departureInfo: some View {
        VStack(alignment: .leading) {
            Text("DEPARTURE INFO")
                .font(.title)
            Text("Departure Time")
                .font(.caption)
            Text(getDateString(transport.startDate))
                .font(.headline)

            if let location = transport.departureLocation {
                Text("Location")
                    .font(.caption)
                Text(location)
            }

            if let address = transport.departureAddress {
                Text("Address")
                    .font(.caption)
                Text(address)
            }
        }
    }

    var arrivalInfo: some View {
        VStack(alignment: .leading) {
            Text("ARRIVAL INFO")
                .font(.title)

            if let endDate = transport.endDate {
                Text("Arrival Time")
                    .font(.caption)
                Text(getDateString(endDate))
                    .font(.headline)
            }

            if let location = transport.arrivalLocation {
                Text("Location")
                    .font(.caption)
                Text(location)
            }

            if let address = transport.arrivalAddress {
                Text("Address")
                    .font(.caption)
                Text(address)
            }
        }
    }

    var transportationDetails: some View {
        VStack(alignment: .leading) {
            Text("TRANSPORTATION DETAILS")
                .font(.title)

            if let vehicleDescription = transport.vehicleDescription {
                Text("Description")
                    .font(.caption)
                Text(vehicleDescription)
            }

            if let numberOfPassengers = transport.numberOfPassengers {
                Text("Number of Passengers")
                    .font(.caption)
                Text(numberOfPassengers)
            }
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                departureInfo.padding()
                arrivalInfo.padding()
                transportationDetails.padding()
                Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(transport.name)
    }
}

// struct TransportView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransportView()
//    }
// }
