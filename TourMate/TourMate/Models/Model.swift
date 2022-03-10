//
//  Model.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

protocol Model {
    var trips: [Trip] { get set }

    func addTrip(_ trip: Trip)

    func updateTrip(from target: Trip, to editedTrip: Trip)

    func deleteTrip(_ target: Trip)

    func addPlan(_ plan: Plan, toTrip trip: Trip)

    func updatePlan(from target: Plan, to editedPlan: Plan, inTrip trip: Trip)

    func deletePlan(_ taget: Plan, fromTrip trip: Trip)
}
