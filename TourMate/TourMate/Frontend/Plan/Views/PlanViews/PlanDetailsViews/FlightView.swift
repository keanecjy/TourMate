//
//  FlightView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct FlightView: View {
    @StateObject var flightViewModel: PlanViewModel<Flight>
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    func getDateString(_ date: Date) -> String {
        guard let flight = flightViewModel.plan else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = flight.startDateTime.timeZone
        return dateFormatter.string(from: date)
    }

    var flightInfo: some View {
        VStack(alignment: .leading) {
            if let flight = flightViewModel.plan {
                Text("Flight Info").font(.title)
                Text("Airline")
                    .font(.caption)
                Text(flight.airline ?? "airline")
                Text("Flight number")
                    .font(.caption)
                Text(flight.flightNumber ?? "flight number")
                if let seats = flight.seats {
                    Text("Seats")
                        .font(.caption)
                    Text(seats)
                }
            }
        }
    }

    var departureInfo: some View {
        VStack(alignment: .leading) {
            if let flight = flightViewModel.plan {
                Text("DEPARTURE INFO")
                    .font(.title)
                Text("Time")
                    .font(.caption)
                Text(getDateString(flight.startDateTime.date))
                    .font(.headline)

                if let location = flight.startLocation {
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
    }

    var arrivalInfo: some View {
        VStack(alignment: .leading) {
            if let flight = flightViewModel.plan {
                Text("ARRIVAL INFO")
                    .font(.title)

                Text("Arrival Time")
                    .font(.caption)
                Text(getDateString(flight.endDateTime.date))
                    .font(.headline)

                if let location = flight.endLocation {
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
    }

    var body: some View {
        if flightViewModel.hasError {
            Text("Error occurred")
        } else {
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
            .navigationTitle(flightViewModel.plan?.name ?? "Flight")
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
                            await flightViewModel.fetchPlan()

                            // TODO: UI Fix
                            // There is a lag between setting the plan to nil
                            // And when we dismiss this view
                            // Maybe need to see how to change the logic
                            if flightViewModel.plan == nil {
                                dismiss()
                            }
                        }
                    } content: {
                        if let flight = flightViewModel.plan {
                            EditFlightView(flight: flight)
                        } else {
                            Text("Error")
                        }
                    }
                }
            }
            .task {
                await flightViewModel.fetchPlan()
            }
        }
    }
}

// struct FlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightView()
//    }
// }
