//
//  IconUtil.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import Foundation

final class IconUtil {
    private init() {}

    static func getIconString(_ plan: Plan) -> String {
        switch plan {
        case _ as Activity:
            return "theatermasks.circle.fill"
        case _ as Accommodation:
            return "bed.double.circle.fill"
        case _ as Transport:
            return "car.circle.fill"
        default:
            return ""
        }
    }
}
