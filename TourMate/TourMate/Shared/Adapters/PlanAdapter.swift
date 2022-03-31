//
//  PlanAdapter.swift
//  TourMate
//
//  Created by Keane Chan on 19/3/22.
//

class PlanAdapter {
    init() {}

    func toAdaptedPlan(plan: Plan) -> FirebaseAdaptedPlan {
        plan.toData()
    }

    func toPlan(adaptedPlan: FirebaseAdaptedPlan) -> Plan {
        adaptedPlan.toItem()
    }
}

extension Plan {
    fileprivate func toData() -> FirebaseAdaptedPlan {
        FirebaseAdaptedPlan(id: id, tripId: tripId, name: name,
                            startDateTime: startDateTime.toData(),
                            endDateTime: endDateTime.toData(),
                            startLocation: startLocation,
                            endLocation: endLocation,
                            imageUrl: imageUrl, status: status.rawValue,
                            creationDate: creationDate, modificationDate: modificationDate,
                            upvotedUserIds: upvotedUserIds,
                            additionalInfo: additionalInfo)
    }
}

extension FirebaseAdaptedPlan {
    fileprivate func toItem() -> Plan {
        Plan(id: id, tripId: tripId, name: name,
             startDateTime: startDateTime.toItem(),
             endDateTime: endDateTime.toItem(),
             startLocation: startLocation,
             endLocation: endLocation,
             imageUrl: imageUrl, status: PlanStatus(rawValue: status)!,
             creationDate: creationDate, modificationDate: modificationDate,
             upvotedUserIds: upvotedUserIds,
             additionalInfo: additionalInfo)
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
