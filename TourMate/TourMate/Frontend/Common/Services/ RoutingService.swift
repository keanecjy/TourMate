//
//   RoutingService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 16/4/22.
//

import Foundation

protocol RoutingService {
    func fetchTransportationOptions(from: Location, to: Location) async -> ([RoutingResult], String)
}
