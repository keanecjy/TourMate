//
//  FirebaseAdaptedTrip.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/3/22.
//

import Foundation
import FirebaseFirestoreSwift

struct FirebaseAdaptedTrip: Codable {
    @DocumentID var id: String?
    var name: String
    var imageUrl: String
    var plans: [FirebaseAdaptedPlan]

    private enum FirebaseAdaptedTripKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case plans
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FirebaseAdaptedTripKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.plans = try container.decode([AnyFirebaseAdaptedPlan].self, forKey: .plans).map({ $0.base })
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FirebaseAdaptedTripKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(plans.map(AnyFirebaseAdaptedPlan.init), forKey: .plans)
    }
}
