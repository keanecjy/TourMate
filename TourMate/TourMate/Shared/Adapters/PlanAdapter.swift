//
//  PlanAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 19/3/22.
//

import Darwin

class PlanAdapter {
    init() {}

    func toAdaptedPlan(plan: Plan) -> FirebaseAdaptedPlan {
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

    func toPlan(adaptedPlan: FirebaseAdaptedPlan) -> Plan {
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
                                     startDateTime: startDateTime.toData(),
                                     endDateTime: endDateTime.toData(),
                                     startLocation: startLocation?.toData(),
                                     endLocation: endLocation?.toData(),
                                     imageUrl: imageUrl, status: status.rawValue,
                                     creationDate: creationDate, modificationDate: modificationDate,
                                     upvotedUserIds: upvotedUserIds,
                                     phone: phone, website: website)
    }
}

extension Activity {
    fileprivate func toData() -> FirebaseAdaptedActivity {
        FirebaseAdaptedActivity(id: id, tripId: tripId, name: name,
                                startDateTime: startDateTime.toData(),
                                endDateTime: endDateTime.toData(),
                                startLocation: startLocation?.toData(),
                                endLocation: endLocation?.toData(),
                                imageUrl: imageUrl, status: status.rawValue,
                                creationDate: creationDate, modificationDate: modificationDate,
                                upvotedUserIds: upvotedUserIds,
                                venue: venue, phone: phone, website: website)
    }
}

extension Restaurant {
    fileprivate func toData() -> FirebaseAdaptedRestaurant {
        FirebaseAdaptedRestaurant(id: id, tripId: tripId, name: name,
                                  startDateTime: startDateTime.toData(),
                                  endDateTime: endDateTime.toData(),
                                  startLocation: startLocation?.toData(),
                                  endLocation: endLocation?.toData(),
                                  imageUrl: imageUrl, status: status.rawValue,
                                  creationDate: creationDate, modificationDate: modificationDate,
                                  upvotedUserIds: upvotedUserIds,
                                  phone: phone, website: website)
    }
}

extension Transport {
    fileprivate func toData() -> FirebaseAdaptedTransport {
        FirebaseAdaptedTransport(id: id, tripId: tripId, name: name,
                                 startDateTime: startDateTime.toData(),
                                 endDateTime: endDateTime.toData(),
                                 startLocation: startLocation?.toData(),
                                 endLocation: endLocation?.toData(),
                                 imageUrl: imageUrl, status: status.rawValue,
                                 creationDate: creationDate, modificationDate: modificationDate,
                                 upvotedUserIds: upvotedUserIds,
                                 vehicleDescription: vehicleDescription, numberOfPassengers: numberOfPassengers)
    }
}

extension Flight {
    fileprivate func toData() -> FirebaseAdaptedFlight {
        FirebaseAdaptedFlight(id: id, tripId: tripId, name: name,
                              startDateTime: startDateTime.toData(),
                              endDateTime: endDateTime.toData(),
                              startLocation: startLocation?.toData(),
                              endLocation: endLocation?.toData(),
                              imageUrl: imageUrl, status: status.rawValue,
                              creationDate: creationDate, modificationDate: modificationDate,
                              upvotedUserIds: upvotedUserIds,
                              airline: airline, flightNumber: flightNumber, seats: seats,
                              departureTerminal: departureTerminal,
                              departureGate: departureGate,
                              arrivalTerminal: arrivalTerminal,
                              arrivalGate: arrivalGate)
    }
}

extension FirebaseAdaptedAccommodation {
    fileprivate func toItem() -> Accommodation {
        Accommodation(id: id, tripId: tripId, name: name,
                      startDateTime: startDateTime.toItem(),
                      endDateTime: endDateTime.toItem(),
                      startLocation: startLocation?.toItem(),
                      endLocation: endLocation?.toItem(),
                      imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                      creationDate: creationDate, modificationDate: modificationDate,
                      upvotedUserIds: upvotedUserIds,
                      phone: phone, website: website)
    }
}

extension FirebaseAdaptedActivity {
    fileprivate func toItem() -> Activity {
        Activity(id: id, tripId: tripId, name: name,
                 startDateTime: startDateTime.toItem(),
                 endDateTime: endDateTime.toItem(),
                 startLocation: startLocation?.toItem(),
                 endLocation: endLocation?.toItem(),
                 imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                 creationDate: creationDate, modificationDate: modificationDate,
                 upvotedUserIds: upvotedUserIds,
                 venue: venue, phone: phone, website: website)
    }
}

extension FirebaseAdaptedRestaurant {
    fileprivate func toItem() -> Restaurant {
        Restaurant(id: id, tripId: tripId, name: name,
                   startDateTime: startDateTime.toItem(),
                   endDateTime: endDateTime.toItem(),
                   startLocation: startLocation?.toItem(),
                   endLocation: endLocation?.toItem(),
                   imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                   creationDate: creationDate, modificationDate: modificationDate,
                   upvotedUserIds: upvotedUserIds,
                   phone: phone, website: website)
    }
}

extension FirebaseAdaptedTransport {
    fileprivate func toItem() -> Transport {
        Transport(id: id, tripId: tripId, name: name,
                  startDateTime: startDateTime.toItem(),
                  endDateTime: endDateTime.toItem(),
                  startLocation: startLocation?.toItem(),
                  endLocation: endLocation?.toItem(),
                  imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
                  creationDate: creationDate, modificationDate: modificationDate,
                  upvotedUserIds: upvotedUserIds,
                  vehicleDescription: vehicleDescription, numberOfPassengers: numberOfPassengers)
    }
}

extension FirebaseAdaptedFlight {
    fileprivate func toItem() -> Flight {
        Flight(id: id, tripId: tripId, name: name,
               startDateTime: startDateTime.toItem(),
               endDateTime: endDateTime.toItem(),
               startLocation: startLocation?.toItem(),
               endLocation: endLocation?.toItem(),
               imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
               creationDate: creationDate, modificationDate: modificationDate,
               upvotedUserIds: upvotedUserIds,
               airline: airline, flightNumber: flightNumber, seats: seats,
               arrivalTerminal: arrivalTerminal, arrivalGate: arrivalGate)
    }
}

extension DateTime {
    fileprivate func toData() -> FirebaseAdaptedDateTime {
        FirebaseAdaptedDateTime(date: date, timeZone: timeZone)
    }
}

extension FirebaseAdaptedDateTime {
    fileprivate func toItem() -> DateTime {
        DateTime(date: date, timeZone: timeZone)
    }
}

extension Location {
    fileprivate func toData() -> JsonAdaptedLocation {
        JsonAdaptedLocation(address_line1: addressLineOne,
                            address_line2: addressLineTwo,
                            formatted: addressFull,
                            lon: longitude, lat: latitude)
    }
}

extension JsonAdaptedLocation {
    fileprivate func toItem() -> Location {
        Location(addressLineOne: address_line1,
                 addressLineTwo: address_line2,
                 addressFull: formatted,
                 longitude: lon, latitude: lat)
    }
}
