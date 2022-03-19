//
//  PlanAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 19/3/22.
//
class PlanAdapter {
    static func toAdaptedPlan(plan: Plan) -> FirebaseAdaptedPlan {
        plan.toData()
    }

    static func toPlan(adaptedPlan: FirebaseAdaptedPlan) -> Plan {
        adaptedPlan.toItem()
    }
}

extension Plan {
    fileprivate func toData() -> FirebaseAdaptedPlan {
        fatalError("Should not be called since this is a protocol")
    }
}

extension FirebaseAdaptedPlan {
    fileprivate func toItem() -> Plan {
        fatalError("Should not be called since this is a protocol")
    }
}

extension Accommodation {
    fileprivate func toData() -> FirebaseAdaptedAccommodation {
        FirebaseAdaptedAccommodation(id: id, tripId: tripId, name: name,
                                     startDate: startDate, endDate: endDate,
                                     timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                                     creationDate: creationDate, modificationDate: modificationDate,
                                     address: address, phone: phone, website: website)
    }
}

extension Activity {
    fileprivate func toData() -> FirebaseAdaptedActivity {
        FirebaseAdaptedActivity(id: id, tripId: tripId, name: name,
                                startDate: startDate, endDate: endDate,
                                timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                                creationDate: creationDate, modificationDate: modificationDate,
                                venue: venue, address: address, phone: phone, website: website)
    }
}

extension Restaurant {
    fileprivate func toData() -> FirebaseAdaptedRestaurant {
        FirebaseAdaptedRestaurant(id: id, tripId: tripId, name: name,
                                  startDate: startDate, endDate: endDate,
                                  timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                                  creationDate: creationDate, modificationDate: modificationDate,
                                  address: address, phone: phone, website: website)
    }
}

extension Transport {
    fileprivate func toData() -> FirebaseAdaptedTransport {
        FirebaseAdaptedTransport(id: id, tripId: tripId, name: name,
                                 startDate: startDate, endDate: endDate,
                                 timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                                 creationDate: creationDate, modificationDate: modificationDate,
                                 departureLocation: departureLocation, departureAddress: departureAddress,
                                 arrivalLocation: arrivalLocation, arrivalAddress: arrivalAddress,
                                 vehicleDescription: vehicleDescription, numberOfPassengers: numberOfPassengers)
    }
}

extension Flight {
    fileprivate func toData() -> FirebaseAdaptedFlight {
        FirebaseAdaptedFlight(id: id, tripId: tripId, name: name,
                              startDate: startDate, endDate: endDate,
                              timeZone: timeZone, imageUrl: imageUrl, status: status.rawValue,
                              creationDate: creationDate, modificationDate: modificationDate,
                              airline: airline, flightNumber: flightNumber ?? 0, seats: seats,
                              departureLocation: departureLocation, departureTerminal: departureTerminal,
                              departureGate: departureGate,
                              arrivalLocation: arrivalLocation, arrivalTerminal: arrivalTerminal,
                              arrivalGate: arrivalGate)
    }
}

extension FirebaseAdaptedAccommodation {
    fileprivate func toItem() -> Accommodation {
        Accommodation(id: id, tripId: tripId, name: name,
                      startDate: startDate, endDate: endDate,
                      timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                      creationDate: creationDate, modificationDate: modificationDate,
                      address: address, phone: phone, website: website)
    }
}

extension FirebaseAdaptedActivity {
    fileprivate func toItem() -> Activity {
        Activity(id: id, tripId: tripId, name: name,
                 startDate: startDate, endDate: endDate,
                 timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                 creationDate: creationDate, modificationDate: modificationDate,
                 venue: venue, address: address, phone: phone, website: website)
    }
}

extension FirebaseAdaptedRestaurant {
    fileprivate func toRestaurant() -> Restaurant {
        Restaurant(id: id, tripId: tripId, name: name,
                   startDate: startDate, endDate: endDate,
                   timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                   creationDate: creationDate, modificationDate: modificationDate,
                   address: address, phone: phone, website: website)
    }
}

extension FirebaseAdaptedTransport {
    fileprivate func toItem() -> Transport {
        Transport(id: id, tripId: tripId, name: name,
                  startDate: startDate, endDate: endDate,
                  timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                  creationDate: creationDate, modificationDate: modificationDate,
                  departureLocation: departureLocation, departureAddress: departureAddress,
                  arrivalLocation: arrivalLocation, arrivalAddress: arrivalAddress,
                  vehicleDescription: vehicleDescription, numberOfPassengers: numberOfPassengers)
    }
}

extension FirebaseAdaptedFlight {
    fileprivate func toItem() -> Flight {
        Flight(id: id, tripId: tripId, name: name,
               startDate: startDate, endDate: endDate,
               timeZone: timeZone, imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
               creationDate: creationDate, modificationDate: modificationDate,
               airline: airline, flightNumber: flightNumber, seats: seats, departureLocation: departureLocation,
               departureTerminal: departureTerminal, departureGate: departureGate, arrivalLocation: arrivalLocation,
               arrivalTerminal: arrivalTerminal, arrivalGate: arrivalGate)
    }
}
