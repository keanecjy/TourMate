//
//  PlansMapDayView.swift
//  TourMate
//
//  Created by Rayner Lim on 11/4/22.
//

import SwiftUI
import MapKit

struct PlansMapDayView: View {
    @ObservedObject var viewModel: PlansViewModel
    private let viewModelFactory = ViewModelFactory()

    let date: Date
    let plans: [Plan]
    let onSelected: ((Plan) -> Void)?

    @State private var selectedItem = 1
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900,
                                           longitude: -122.009_020),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )

    init(viewModel: PlansViewModel,
         date: Date,
         plans: [Plan] = [],
         onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.date = date
        self.plans = plans
        self.onSelected = onSelected
    }

    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
                .frame(maxWidth: .infinity, minHeight: 400)
            /*
            TabView(selection: $selectedItem) {
                ForEach(0..<plans.count, id: \.self) { number in
                    PlanCardView(planUpvoteViewModel: viewModelFactory.getPlanUpvoteViewModel(plan: plans[number]),
                                 plan: plans[number],
                                 date: date)
                    .onTapGesture(perform: {
                        if let onSelected = onSelected {
                            onSelected(plans[number])
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                    .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color.primary.opacity(0.1)))
                    .tag(number)
                }
            }
            .tabViewStyle(.page)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 100.0)
            .onChange(of: selectedItem) { value in
                print("selected tab = \(value)")
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: viewModel.sortedPlans[value].startLocation?.latitude ?? 0,
                        longitude: viewModel.sortedPlans[value].startLocation?.longitude ?? 0
                    ),
                    latitudinalMeters: 750,
                    longitudinalMeters: 750
                )
            }
            */
        }
    }
}
