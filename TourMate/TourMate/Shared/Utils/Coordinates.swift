//
//  Coordinates.swift
//  TourMate
//
//  Created by Rayner Lim on 15/4/22.
//

import Foundation
import CoreLocation

func degreesToRadians(_ angle: CLLocationDegrees) -> Double {
    angle / 180.0 * .pi
}

func radiansToDegrees(_ radian: Double) -> CLLocationDegrees {
    CLLocationDegrees(radian * 180.0 / .pi)
}

func getGeographicMidpoint(betweenCoordinates coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {

    guard coordinates.count > 1 else {
        return coordinates.first ?? // return the only coordinate
            CLLocationCoordinate2D(latitude: 0, longitude: 0) // return null island if no coordinates were given
    }

    guard coordinates.count > 1 else {
        return coordinates.first ?? // return the only coordinate
            CLLocationCoordinate2D(latitude: 0, longitude: 0) // return null island if no coordinates were given
    }

    var x = Double(0)
    var y = Double(0)
    var z = Double(0)

    for coordinate in coordinates {
        let lat = degreesToRadians(coordinate.latitude)
        let lon = degreesToRadians(coordinate.longitude)
        x += cos(lat) * cos(lon)
        y += cos(lat) * sin(lon)
        z += sin(lat)
    }

    x /= Double(coordinates.count)
    y /= Double(coordinates.count)
    z /= Double(coordinates.count)

    let lon = atan2(y, x)
    let hyp = sqrt(x * x + y * y)
    let lat = atan2(z, hyp)

    return CLLocationCoordinate2D(latitude: radiansToDegrees(lat), longitude: radiansToDegrees(lon))
}
