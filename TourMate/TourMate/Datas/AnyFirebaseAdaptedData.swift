//
//  AnyFirebaseAdaptedData.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

struct AnyFirebaseAdaptedData: Codable {
    var base: FirebaseAdaptedData

    init(_ base: FirebaseAdaptedData) {
        self.base = base
    }

    private enum AnyFirebaseAdaptedDataKeys: CodingKey {
        case type, base
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyFirebaseAdaptedDataKeys.self)
        let type = try container.decode(FirebaseAdaptedType.self, forKey: .type)
        self.base = try type.metatype.init(from: container.superDecoder(forKey: .base))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyFirebaseAdaptedDataKeys.self)
        try container.encode(type(of: base).type, forKey: .type)
        try base.encode(to: container.superEncoder(forKey: .base))
    }
}
