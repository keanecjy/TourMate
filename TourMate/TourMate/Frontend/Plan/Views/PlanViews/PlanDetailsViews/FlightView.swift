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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = flightViewModel.plan.startDateTime.timeZone
        return dateFormatter.string(from: date)
    }

    var votingInfo: some View {
        HStack(spacing: 10.0) {
            if let flight = flightViewModel.plan {
                PlanStatusView(status: flight.status)
                    .padding()

                if flight.status == .proposed {
                    UpvotePlanView(viewModel: flightViewModel)
                }
            }
        }
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

    var comments: some View {
        CommentsView(commentsViewModel: flightViewModel.commentsViewModel)
    }

    var body: some View {
        if flightViewModel.hasError {
            Text("Error occurred")
        } else {
            HStack {
                VStack(alignment: .leading) {
                    votingInfo.padding()
                    flightInfo.padding()
                    departureInfo.padding()
                    arrivalInfo.padding()
                    comments.padding()
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .navigationTitle(flightViewModel.plan.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditFlightView(viewModel: flightViewModel)
                    }
                }
            }
            .task {
                await flightViewModel.fetchPlanAndListen()
            }
            .onReceive(flightViewModel.objectWillChange) {
                if flightViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in flightViewModel.detachListener() })
        }
    }
}

// struct FlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightView()
//    }
// }
