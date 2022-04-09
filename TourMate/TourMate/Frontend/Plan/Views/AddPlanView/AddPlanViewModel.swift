//
//  AddPlanFormViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

 import Foundation
 import Combine

 @MainActor
 class AddPlanViewModel: PlanFormViewModel {
    @Published var isLoading = false
    @Published private(set) var hasError = false

    let trip: Trip
    let planService: PlanService
    let userService: UserService

    init(trip: Trip, planService: PlanService = FirebasePlanService(), userService: UserService = FirebaseUserService()) {

        self.trip = trip
        self.planService = planService
        self.userService = userService

        super.init(lowerBoundDate: trip.startDateTime.date, upperBoundDate: trip.endDateTime.date)
    }
 }

 // MARK: - State changes
 extension AddPlanViewModel {
    func handleError() {
        self.hasError = true
        self.isLoading = false
    }
 }
