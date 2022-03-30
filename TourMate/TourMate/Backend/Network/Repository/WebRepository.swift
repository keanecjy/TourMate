//
//  WebRepository.swift
//  TourMate
//
//  Created by Tan Rui Quan on 30/3/22.
//

import Foundation
import Combine

//https://github.com/nalexn/clean-architecture-swiftui/blob/mvvm/CountriesSwiftUI/Utilities/WebRepository.swift
protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func call<Value>(endPoint: APICall, httpCodes: HTTPCodes = .success) async -> (items: Value?, errorMessage: String) where Value: Decodable {
        do {
            let request = try endPoint.urlRequest(baseURL: baseURL)
            let (data, _) = try await session.data(for: request)
            let items = try JSONDecoder().decode(Value.self, from: data)
            return (items, "")
        } catch {
            let errorMessage = "[WebRepository] Error calling api: \(error)"
            return (nil, errorMessage)
        }
    }

    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error>
        where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            return session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
        } catch {
            return Fail<Value, Error>(error: error)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Helpers
extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
        tryMap {
            assert(!Thread.isMainThread)
            guard let code = ($0.response as? HTTPURLResponse)?.statusCode else {
                throw APIError.unexpectedResponse
            }
            guard httpCodes.contains(code) else {
                throw APIError.httpCode(code)
            }
            return $0.data
        }
        .decode(type: Value.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
