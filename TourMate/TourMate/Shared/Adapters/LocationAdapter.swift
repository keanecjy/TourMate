//
//  LocationAdapter.swift
//  TourMate
//
//  Created by Tan Rui Quan on 30/3/22.
//

import Foundation

class LocationAdapter {
    init() {}

    func toAdaptedLocation(location: Location) -> JsonAdaptedLocation {
        location.toData()
    }

    func toLocation(adaptedLocation: JsonAdaptedLocation) -> Location {
        adaptedLocation.toItem()
    }
}

extension Location {
    fileprivate func toData() -> JsonAdaptedLocation {
        JsonAdaptedLocation(country: country,
                            address_line1: addressLineOne,
                            address_line2: addressLineTwo,
                            formatted: addressFull,
                            lon: longitude,
                            lat: latitude)
    }
}

extension JsonAdaptedLocation {
    fileprivate func toItem() -> Location {
        Location(country: country,
                 addressLineOne: address_line1,
                 addressLineTwo: address_line2,
                 addressFull: formatted,
                 longitude: lon,
                 latitude: lat)
    }
}
