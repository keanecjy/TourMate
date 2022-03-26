//
//  TransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct TransportView: View {
    @StateObject var transportViewModel: PlanViewModel<Transport>
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = transportViewModel.plan.startDateTime.timeZone
        return dateFormatter.string(from: date)
    }

    var departureInfo: some View {
        VStack(alignment: .leading) {
            if let transport = transportViewModel.plan {
                Text("DEPARTURE INFO")
                    .font(.title)
                Text("Departure Time")
                    .font(.caption)
                Text(getDateString(transport.startDateTime.date))
                    .font(.headline)
                Text("Location").font(.caption)
                Text(transport.startLocation)
            }
        }
    }

    var arrivalInfo: some View {
        VStack(alignment: .leading) {
            if let transport = transportViewModel.plan {
                Text("ARRIVAL INFO")
                    .font(.title)

                Text("Arrival Time")
                    .font(.caption)
                Text(getDateString(transport.endDateTime.date))
                    .font(.headline)

                if let location = transport.endLocation {
                    Text("Location")
                        .font(.caption)
                    Text(location)
                }
            }
        }
    }

    var transportationDetails: some View {
        VStack(alignment: .leading) {
            if let transport = transportViewModel.plan {
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
    }

    var body: some View {
        if transportViewModel.hasError {
            Text("Error occurred")
        } else {
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
            .navigationBarTitle(transportViewModel.plan.name)
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
                            await transportViewModel.fetchPlan()

                            // TODO: UI Fix
                            // There is a lag between setting the plan to nil
                            // And when we dismiss this view
                            // Maybe need to see how to change the logic
                            if transportViewModel.isDeleted {
                                dismiss()
                            }
                        }
                    } content: {
                        EditTransportView(viewModel: transportViewModel)
                    }
                }
            }
            .task {
                await transportViewModel.fetchPlan()
            }
        }
    }
}

// struct TransportView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransportView()
//    }
// }
