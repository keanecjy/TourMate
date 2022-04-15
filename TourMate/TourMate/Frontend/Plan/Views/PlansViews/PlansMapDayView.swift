//
//  PlansMapDayView.swift
//  TourMate
//
//  Created by Rayner Lim on 11/4/22.
//

import SwiftUI
import MapKit

struct IdentifiableLocation: Identifiable {
    let id: Int
    let coordinate: CLLocationCoordinate2D
}

struct PlansMapDayView: View {
    @ObservedObject var viewModel: PlansViewModel
    private let viewModelFactory = ViewModelFactory()

    let date: Date
    let plans: [(Int, Plan)]
    let onSelected: ((Plan) -> Void)?

    var locations: [IdentifiableLocation] {
        plans.compactMap { index, plan in
            guard let location = plan.locations.first else {
                return nil
            }
            return IdentifiableLocation(
                id: index,
                coordinate: CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            )
        }
    }

    @State private var selectedItem = 0
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900,
                                           longitude: -122.009_020),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )

    init(viewModel: PlansViewModel,
         date: Date,
         plans: [(Int, Plan)] = [],
         onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.date = date
        self.plans = plans
        self.onSelected = onSelected
    }

    func handleSelectedItemChanged(_ value: Int) {
        guard plans.indices.contains(value) else {
            return
        }
        let plan = plans[value].1
        guard let location = plan.locations.first else {
            return
        }
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                            .offset(x: 0, y: 16)
                        Text(String(location.id + 1))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            TabView(selection: $selectedItem) {
                ForEach(plans, id: \.0) { index, plan in
                    PlanCardView(plansViewModel: viewModel,
                                 plan: plan,
                                 date: date)
                    .onTapGesture(perform: {
                        if let onSelected = onSelected {
                            onSelected(plan)
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                    .background(RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.primary.opacity(0.5), radius: 4)
                    )
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 100.0)
            .onChange(of: selectedItem) { value in
                handleSelectedItemChanged(value)
            }
        }
        .onAppear {
            handleSelectedItemChanged(selectedItem)
        }
    }
}
