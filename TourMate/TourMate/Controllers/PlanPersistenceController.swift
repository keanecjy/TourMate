//
//  PlanPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import FirebaseAuth

struct PlanPersistenceController {
    let firebasePersistenceManager = FirebasePersistenceManager(collectionId: FirebaseConfig.planCollectionId)

    func addPlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: plan.id, item: plan.toData())
    }

    func fetchPlans(tripId: String) async -> ([Plan], String) {
        let (adaptedPlans, errorMessage) = await firebasePersistenceManager
            .fetchItems(field: "tripId", isEqualTo: tripId)

        guard let adaptedPlans = adaptedPlans as? [FirebaseAdaptedPlan] else {
            fatalError("Cannot convert to plans")
        }

        let plans = adaptedPlans.map({ $0.toItem() })
            .sorted(by: { $0.creationDate < $1.creationDate })
        return (plans, errorMessage)
    }

    func deletePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.deleteItem(id: plan.id)
    }

    func updatePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.updateItem(id: plan.id, item: plan.toData())
    }
}

extension Plan {
    fileprivate func toData() -> FirebaseAdaptedPlan {
        preconditionFailure()
    }
}

extension FirebaseAdaptedPlan {
    fileprivate func toItem() -> Plan {
        preconditionFailure()
    }
}

extension Accommodation {
    fileprivate func toData() -> FirebaseAdaptedAccommodation {
        FirebaseAdaptedAccommodation(id: id, tripId: tripId, planType: FirebasePlanType(rawValue: planType.rawValue)!,
                                     name: name, startDate: startDate, endDate: endDate,
                                     timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                                     creationDate: creationDate, modificationDate: modificationDate,
                                     address: address, phone: phone, website: website)
    }
}

extension Activity {
    fileprivate func toData() -> FirebaseAdaptedActivity {
        FirebaseAdaptedActivity(id: id, tripId: tripId, planType: FirebasePlanType(rawValue: planType.rawValue)!,
                                name: name, startDate: startDate, endDate: endDate,
                                timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                                creationDate: creationDate, modificationDate: modificationDate,
                                venue: venue, address: address, phone: phone, website: website)
    }
}

extension Restaurant {
    fileprivate func toData() -> FirebaseAdaptedRestaurant {
        FirebaseAdaptedRestaurant(id: id, tripId: tripId, planType: FirebasePlanType(rawValue: planType.rawValue)!,
                                  name: name, startDate: startDate, endDate: endDate,
                                  timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                                  creationDate: creationDate, modificationDate: modificationDate,
                                  address: address, phone: phone, website: website)
    }
}

extension Transport {
    fileprivate func toData() -> FirebaseAdaptedTransport {
        FirebaseAdaptedTransport(id: id, tripId: tripId, planType: FirebasePlanType(rawValue: planType.rawValue)!,
                                 name: name, startDate: startDate, endDate: endDate,
                                 timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                                 creationDate: creationDate, modificationDate: modificationDate,
                                 departureLocation: departureLocation, departureAddress: departureAddress,
                                 arrivalLocation: arrivalLocation, arrivalAddress: arrivalAddress,
                                 vehicleDescription: vehicleDescription, numberOfPassengers: numberOfPassengers)
    }
}

extension Flight {
    fileprivate func toData() -> FirebaseAdaptedFlight {
        FirebaseAdaptedFlight(id: id, tripId: tripId, planType: FirebasePlanType(rawValue: planType.rawValue)!,
                              name: name, startDate: startDate, endDate: endDate,
                              timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                              creationDate: creationDate, modificationDate: modificationDate,
                              airline: airline, flightNumber: flightNumber, seats: seats,
                              departureLocation: departureLocation, departureTerminal: departureTerminal,
                              departureGate: departureGate, arrivalLocation: arrivalLocation,
                              arrivalTerminal: arrivalTerminal, arrivalGate: arrivalGate)
    }
}

extension FirebaseAdaptedAccommodation {
    fileprivate func toItem() -> Accommodation {
        Accommodation(id: id, tripId: tripId, planType: PlanType(rawValue: planType.rawValue)!,
                      name: name, startDate: startDate, endDate: endDate,
                      timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                      creationDate: creationDate, modificationDate: modificationDate,
                      address: address, phone: phone, website: website)
    }
}

extension FirebaseAdaptedActivity {
    fileprivate func toItem() -> Activity {
        Activity(id: id, tripId: tripId, planType: PlanType(rawValue: planType.rawValue)!,
                 name: name, startDate: startDate, endDate: endDate,
                 timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                 creationDate: creationDate, modificationDate: modificationDate,
                 venue: venue, address: address, phone: phone, website: website)
    }
}

extension FirebaseAdaptedRestaurant {
    fileprivate func toRestaurant() -> Restaurant {
        Restaurant(id: id, tripId: tripId, planType: PlanType(rawValue: planType.rawValue)!,
                   name: name, startDate: startDate, endDate: endDate,
                   timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                   creationDate: creationDate, modificationDate: modificationDate,
                   address: address, phone: phone, website: website)
    }
}

extension FirebaseAdaptedTransport {
    fileprivate func toItem() -> Transport {
        Transport(id: id, tripId: tripId, planType: PlanType(rawValue: planType.rawValue)!,
                  name: name, startDate: startDate, endDate: endDate,
                  timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                  creationDate: creationDate, modificationDate: modificationDate,
                  departureLocation: departureLocation, departureAddress: departureAddress,
                  arrivalLocation: arrivalLocation, arrivalAddress: arrivalAddress,
                  vehicleDescription: vehicleDescription, numberOfPassengers: numberOfPassengers)
    }
}

extension FirebaseAdaptedFlight {
    fileprivate func toItem() -> Flight {
        Flight(id: id, tripId: tripId, planType: PlanType(rawValue: planType.rawValue)!,
               name: name, startDate: startDate, endDate: endDate,
               timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
               creationDate: creationDate, modificationDate: modificationDate,
               airline: airline, flightNumber: flightNumber, seats: seats, departureLocation: departureLocation,
               departureTerminal: departureTerminal, departureGate: departureGate,
               arrivalLocation: arrivalLocation, arrivalTerminal: arrivalTerminal, arrivalGate: arrivalGate)
    }
}
