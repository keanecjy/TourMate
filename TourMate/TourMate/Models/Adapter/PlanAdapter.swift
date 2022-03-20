//
//  PlanAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 19/3/22.
//
class PlanAdapter {
    static func toAdaptedPlan(plan: Plan) -> FirebaseAdaptedPlan {
        guard let planType = FirebaseAdaptedType(rawValue: plan.planType.rawValue) else {
            preconditionFailure()
        }

        // Will always match correctly since type is a constant value
        switch planType {
        case .accommodation:
            return (plan as! Accommodation).toData()
        case .activity:
            return (plan as! Activity).toData()
        case .restaurant:
            return (plan as! Restaurant).toData()
        case .transport:
            return (plan as! Transport).toData()
        case .flight:
            return (plan as! Flight).toData()
        default:
            preconditionFailure()
        }
    }

    static func toPlan(adaptedPlan: FirebaseAdaptedPlan) -> Plan {
        guard let planType = PlanType(rawValue: adaptedPlan.getType().rawValue) else {
            preconditionFailure()
        }

        // Will always match correctly since type is a constant value
        switch planType {
        case .accommodation:
            return (adaptedPlan as! FirebaseAdaptedAccommodation).toItem()
        case .activity:
            return (adaptedPlan as! FirebaseAdaptedActivity).toItem()
        case .restaurant:
            return (adaptedPlan as! FirebaseAdaptedRestaurant).toItem()
        case .transport:
            return (adaptedPlan as! FirebaseAdaptedTransport).toItem()
        case .flight:
            return (adaptedPlan as! FirebaseAdaptedFlight).toItem()
        }
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
                              airline: airline, flightNumber: flightNumber, seats: seats,
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
    fileprivate func toItem() -> Restaurant {
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
