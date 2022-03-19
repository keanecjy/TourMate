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
        Accommodation(id: "0", tripId: "0",
                      planType: .accommodation,
                      name: "Hotel Z", startDate: Date(timeIntervalSince1970: 1_651_460_400),
                      endDate: Date(timeIntervalSince1970: 1_651_480_400),
                      timeZone: TimeZone(abbreviation: "PST")!,
                      status: .confirmed, creationDate: creationDate,
                      modificationDate: creationDate,
                      address: "23 Fleet Street, The City, London, United Kingdom, EC4Y 1AA",
                      phone: "1_347_810_383",
                      website: "https://www.agoda.com/the-z-hotel-city/hotel/london-gb.html?cid=1844104"),
        Activity(id: "1", tripId: "0", planType: .activity,
                 name: "Visit Tower Bridge",
                 startDate: Date(timeIntervalSince1970: 1_651_460_400),
                 endDate: Date(timeIntervalSince1970: 1_651_467_600),
                 timeZone: TimeZone(abbreviation: "PST")!,
                 imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
                 status: .confirmed, creationDate: creationDate,
                 modificationDate: creationDate, venue: "Tower Bridge",
                 address: "Tower Bridge Rd, London SE1 2UP, United Kingdom",
                 phone: "2_074_033_761",
                 website: "https://www.towerbridge.org.uk/"),
        Restaurant(id: "2", tripId: "0", planType: .restaurant,
                   name: "Dinner at Spago",
                   startDate: Date(timeIntervalSince1970: 1_651_460_400),
                   timeZone: TimeZone(abbreviation: "PST")!, status: .proposed,
                   creationDate: creationDate, modificationDate: creationDate,
                   address: "45 Park Lane, Mayfair Westminster, London",
                   phone: "2_074_934_545",
                   website: "https://wolfgangpuck.com/dining/cut-london/"),
        Transport(id: "3", tripId: "1", planType: .transport,
                  startDate: Date(timeIntervalSince1970: 1_651_460_400),
                  endDate: Date(timeIntervalSince1970: 1_651_480_400),
                  timeZone: TimeZone(abbreviation: "MST")!,
                  status: .confirmed, creationDate: creationDate,
                  modificationDate: creationDate,
                  departureLocation: "Osaka's Kansai Airport",
                  arrivalLocation: "Kyoto",
                  vehicleDescription: "Departures every 30 minutes",
                  numberOfPassengers: "1"),
        Flight(id: "3", tripId: "1", planType: .flight, name: "Flight to Japan",
               startDate: Date(timeIntervalSince1970: 1_651_440_400),
               endDate: Date(timeIntervalSince1970: 1_651_460_400),
               timeZone: TimeZone(abbreviation: "MST")!,
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
