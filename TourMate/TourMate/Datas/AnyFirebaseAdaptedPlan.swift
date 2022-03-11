//
//  AnyFirebaseAdaptedPlan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation

// The solution to polymorphic decoding of JSON data is inspired from:
// https://stackoverflow.com/questions/44441223/encode-decode-array-of-types-conforming-to-protocol-with-jsonencoderter

struct AnyFirebaseAdaptedPlan: Codable {
    var base: FirebaseAdaptedPlan

    init(_ base: FirebaseAdaptedPlan) {
        self.base = base
    }

    private enum AnyFirebaseAdaptedPlanKeys: CodingKey {
        case type, base
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyFirebaseAdaptedPlanKeys.self)
        let type = try container.decode(FirebaseAdaptedPlanType.self, forKey: .type)
        self.base = try type.metatype.init(from: container.superDecoder(forKey: .base))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyFirebaseAdaptedPlanKeys.self)
        try container.encode(type(of: base).type, forKey: .type)
        try base.encode(to: container.superEncoder(forKey: .base))
    }
}
