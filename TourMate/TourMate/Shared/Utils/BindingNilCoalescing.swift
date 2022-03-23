//
//  BindingNilCoalescing.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import SwiftUI

func ??<T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
