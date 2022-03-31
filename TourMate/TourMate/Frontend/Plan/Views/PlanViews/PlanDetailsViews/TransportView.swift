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

    var votingInfo: some View {
        HStack(spacing: 10.0) {
            if let transport = transportViewModel.plan {
                PlanStatusView(status: transport.status)
                    .padding()

                if transport.status == .proposed {
                    UpvotePlanView(viewModel: transportViewModel)
                }
            }
        }
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
                Text(transport.startLocation?.addressFull ?? "")
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

                if let location = transport.endLocation?.addressFull {
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

    var comments: some View {
        CommentsView(commentsViewModel: transportViewModel.commentsViewModel)
    }

    var body: some View {
        if transportViewModel.hasError {
            Text("Error occurred")
        } else {
            HStack {
                VStack(alignment: .leading) {
                    votingInfo.padding()
                    departureInfo.padding()
                    arrivalInfo.padding()
                    transportationDetails.padding()
                    comments.padding()
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
                        EditTransportView(viewModel: transportViewModel)
                    }
                }
            }
            .task {
                await transportViewModel.fetchPlanAndListen()
            }
            .onReceive(transportViewModel.objectWillChange) {
                if transportViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in transportViewModel.detachListener() })
        }
    }
}

// struct TransportView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransportView()
//    }
// }
