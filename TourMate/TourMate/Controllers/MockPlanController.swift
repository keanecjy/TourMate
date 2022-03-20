//
//  MockPlanController.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation

class MockPlanController: PlanPersistenceControllerProtocol {

    static let creationDate = Date(timeIntervalSince1970: 1_651_400_000)

    var plans: [Plan] = [
        Accommodation(id: "0", tripId: "5402530A-6E13-4F65-BFBA-51C491C0FCA1",
                      name: "Hotel Z", startDate: Date(timeIntervalSince1970: 1_651_460_400),
                      endDate: Date(timeIntervalSince1970: 1_651_480_400),
                      startTimeZone: TimeZone(abbreviation: "PST")!,
                      status: .confirmed, creationDate: creationDate,
                      modificationDate: creationDate,
                      address: "23 Fleet Street, The City, London, United Kingdom, EC4Y 1AA",
                      phone: "1_347_810_383",
                      website: "https://www.agoda.com/the-z-hotel-city/hotel/london-gb.html?cid=1844104"),
        Activity(id: "1", tripId: "5402530A-6E13-4F65-BFBA-51C491C0FCA1",
                 name: "Visit Tower Bridge",
                 startDate: Date(timeIntervalSince1970: 1_651_460_400),
                 endDate: Date(timeIntervalSince1970: 1_651_467_600),
                 startTimeZone: TimeZone(abbreviation: "PST")!,
                 imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
                 status: .confirmed, creationDate: creationDate,
                 modificationDate: creationDate, venue: "Tower Bridge",
                 address: "Tower Bridge Rd, London SE1 2UP, United Kingdom",
                 phone: "2_074_033_761",
                 website: "https://www.towerbridge.org.uk/"),
        Restaurant(id: "2", tripId: "5402530A-6E13-4F65-BFBA-51C491C0FCA1",
                   name: "Dinner at Spago",
                   startDate: Date(timeIntervalSince1970: 1_651_460_400),
                   endDate: Date(timeIntervalSince1970: 1_651_461_400),
                   startTimeZone: TimeZone(abbreviation: "PST")!, status: .proposed,
                   creationDate: creationDate, modificationDate: creationDate,
                   address: "45 Park Lane, Mayfair Westminster, London",
                   phone: "2_074_934_545",
                   website: "https://wolfgangpuck.com/dining/cut-london/"),
        Transport(id: "3", tripId: "5402530A-6E13-4F65-BFBA-51C491C0FCA1",
                  startDate: Date(timeIntervalSince1970: 1_651_460_400),
                  endDate: Date(timeIntervalSince1970: 1_651_480_400),
                  startTimeZone: TimeZone(abbreviation: "MST")!,
                  status: .confirmed, creationDate: creationDate,
                  modificationDate: creationDate,
                  departureLocation: "Osaka's Kansai Airport",
                  arrivalLocation: "Kyoto",
                  vehicleDescription: "Departures every 30 minutes",
                  numberOfPassengers: "1"),
        Flight(id: "4", tripId: "5402530A-6E13-4F65-BFBA-51C491C0FCA1",
               name: "Flight to Japan",
               startDate: Date(timeIntervalSince1970: 1_651_440_400),
               endDate: Date(timeIntervalSince1970: 1_651_460_400),
               startTimeZone: TimeZone(abbreviation: "MST")!,
               imageUrl: "https://source.unsplash.com/pT0qBgNa0VU",
               status: .confirmed, creationDate: creationDate,
               modificationDate: creationDate, airline: "Japan Airline",
               flightNumber: "32", seats: "S14",
               departureLocation: "Singapore Changi Airport",
               departureTerminal: "1", departureGate: "4",
               arrivalLocation: "Osaka's Kansai Airport",
               arrivalTerminal: "1", arrivalGate: "2")
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
