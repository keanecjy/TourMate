//
//  FlightView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct FlightView: View {
    let flight: Flight

    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = flight.timeZone
        return dateFormatter.string(from: date)
    }

    var flightInfo: some View {
        VStack(alignment: .leading) {
            Text("Flight Info").font(.title)
            Text("Airline")
                .font(.caption)
            Text(flight.airline)
            Text("Flight number")
                .font(.caption)
            Text(flight.flightNumber)
            if let seats = flight.seats {
                Text("Seats")
                    .font(.caption)
                Text(seats)
            }

        }
    }

    var departureInfo: some View {
        VStack(alignment: .leading) {
            Text("DEPARTURE INFO")
                .font(.title)
            Text("Time")
                .font(.caption)
            Text(getDateString(flight.startDate))
                .font(.headline)

            if let location = flight.departureLocation {
                Text("Location")
                    .font(.caption)
                Text(location)
            }

            if let terminal = flight.departureTerminal {
                Text("Terminal")
                    .font(.caption)
                Text(terminal)
            }

            if let gate = flight.departureGate {
                Text("Gate")
                    .font(.caption)
                Text(gate)
            }

        }
    }

    var arrivalInfo: some View {
        VStack(alignment: .leading) {
            Text("ARRIVAL INFO")
                .font(.title)

            if let endDate = flight.endDate {
                Text("Arrival Time")
                    .font(.caption)
                Text(getDateString(endDate))
                    .font(.headline)
            }

            if let location = flight.arrivalLocation {
                Text("Location")
                    .font(.caption)
                Text(location)
            }

            if let terminal = flight.arrivalTerminal {
                Text("Terminal")
                    .font(.caption)
                Text(terminal)
            }

            if let gate = flight.arrivalGate {
                Text("Gate")
                    .font(.caption)
                Text(gate)
            }
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                flightInfo.padding()
                departureInfo.padding()
                arrivalInfo.padding()
                Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationTitle(flight.name)
    }
}

// struct FlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightView()
//    }
// }
