//
//  InjectedKey.swift
//  TourMate
//
//  Created by Keane Chan on 8/4/22.
//

/// Provides a key for injecting a dependency
public protocol InjectionKey {

    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set }
}
