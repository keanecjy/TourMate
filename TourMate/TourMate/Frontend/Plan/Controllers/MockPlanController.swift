//
//  MockPlanController.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation

class MockPlanController: PlanController {

    static let creationDate = Date(timeIntervalSince1970: 1_651_400_000)

    var plans: [Plan] = [
        Accommodation(id: "0", tripId: "0", name: "Hotel Z",
                      startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400)),
                      endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_480_400)),
                      startLocation: "23 Fleet Street, The City, London, United Kingdom, EC4Y 1AA",
                      status: .confirmed,
                      creationDate: creationDate,
                      modificationDate: creationDate,
                      phone: "1_347_810_383",
                      website: "https://www.agoda.com/the-z-hotel-city/hotel/london-gb.html?cid=1844104"),
        Activity(id: "1", tripId: "0", name: "Visit Tower Bridge",
                 startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400),
                                         timeZone: TimeZone(abbreviation: "PST")!),
                 endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_467_600),
                                       timeZone: TimeZone(abbreviation: "PST")!),
                 startLocation: "Tower Bridge Rd, London SE1 2UP, United Kingdom",
                 imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
                 status: .confirmed, creationDate: creationDate,
                 modificationDate: creationDate, phone: "2_074_033_761",
                 website: "https://www.towerbridge.org.uk/"),
        Restaurant(id: "2", tripId: "0", name: "Dinner at Spago",
                   startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400),
                                           timeZone: TimeZone(abbreviation: "PST")!),
                   endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_461_400),
                                         timeZone: TimeZone(abbreviation: "PST")!),
                   startLocation: "45 Park Lane, Mayfair Westminster, London",
                   status: .confirmed, creationDate: creationDate,
                   modificationDate: creationDate, phone: "2_074_934_545",
                   website: "https://wolfgangpuck.com/dining/cut-london/"),
        Transport(id: "3", tripId: "1", name: "Travel to Kyoto",
                  startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400),
                                          timeZone: TimeZone(abbreviation: "MST")!),
                  endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_480_400),
                                        timeZone: TimeZone(abbreviation: "MST")!),
                  startLocation: "Osaka's Kansai Airport", endLocation: "Kyoto",
                  status: .confirmed, creationDate: creationDate,
                  modificationDate: creationDate,
                  vehicleDescription: "Departs every 30 minutes", numberOfPassengers: "1"),
        Flight(id: "4", tripId: "1", name: "Flight to Japan",
               startDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_440_400),
                                       timeZone: TimeZone(abbreviation: "MST")!),
               endDateTime: DateTime(date: Date(timeIntervalSince1970: 1_651_460_400),
                                     timeZone: TimeZone(abbreviation: "MST")!),
               startLocation: "Singapore Changi Airport", endLocation: "Osaka's Kansai Airport",
               imageUrl: "https://source.unsplash.com/pT0qBgNa0VU",
               status: .confirmed, creationDate: creationDate,
               modificationDate: creationDate, airline: "Japan Airline",
               flightNumber: "32", seats: "S14", departureTerminal: "1",
               departureGate: "4", arrivalTerminal: "1", arrivalGate: "2")
    ]

    func fetchPlans(withTripId tripId: String) async -> ([Plan], String) {
        (plans.filter({ $0.tripId == tripId }), "")
    }

    func fetchPlan(withPlanId planId: String) async -> (Plan?, String) {
        let plan = plans.first(where: { $0.id == planId })
        return (plan, "")
    }

    func addPlan(plan: Plan) async -> (Bool, String) {
        plans.append(plan)
        return (true, "")
    }

    func deletePlan(plan: Plan) async -> (Bool, String) {
        plans = plans.filter({ $0.id != plan.id })
        return (true, "")
    }

    func updatePlan(plan: Plan) async -> (Bool, String) {
        guard let index = plans.firstIndex(where: { $0.id == plan.id }) else {
            return (false, "Plan with planId: \(plan.id) should exist")
        }

        plans[index] = plan
        return (true, "")
    }
}
