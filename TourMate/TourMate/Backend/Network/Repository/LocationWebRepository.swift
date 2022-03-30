//
//  LocationWebRepository.swift
//  TourMate
//
//  Created by Tan Rui Quan on 30/3/22.
//

import Foundation
import Combine

protocol LocationWebRepository: WebRepository {
    func fetchLocations(query: AutocompleteQuery) async -> (locations: [JsonAdaptedLocation], errorMessage: String)

    func fetchLocations(query: AutocompleteQuery) -> AnyPublisher<[JsonAdaptedLocation], Error>
}

struct RealLocationWebRepository: LocationWebRepository {
    var session: URLSession
    var baseURL: String

    init(session: URLSession = URLSession.shared, baseURL: String) {
            self.session = session
            self.baseURL = baseURL
        }

    func fetchLocations(query: AutocompleteQuery) async -> (locations: [JsonAdaptedLocation], errorMessage: String) {
        let (geoapifyResult, errorMessage): (GeoapifyResult?, String) = await call(endPoint: API.autocomplete(query))

        guard errorMessage.isEmpty,
              let geoapifyResult = geoapifyResult else {
                  return ([], errorMessage)
              }

        return (geoapifyResult.results, "")
    }

    func fetchLocations(query: AutocompleteQuery) -> AnyPublisher<[JsonAdaptedLocation], Error> {
        call(endpoint: API.autocomplete(query))
    }
}

extension RealLocationWebRepository {
    enum API {
        case autocomplete(AutocompleteQuery)
    }
}

extension RealLocationWebRepository.API: APICall {
    var path: String {
        switch self {
        case .autocomplete(let query):
            return "/autocomplete\(query.getQuery())"
        }
    }

    var method: String {
        switch self {
        case .autocomplete:
            return "GET"
        }
    }

    var headers: [String: String]? {
        ["Accept": "application/json"]
    }

    func body() -> Data? {
        nil
    }
}
