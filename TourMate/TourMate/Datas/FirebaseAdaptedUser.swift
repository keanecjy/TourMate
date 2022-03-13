//
//  User.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseFirestoreSwift

struct FirebaseAdaptedUser: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var userId: String
    var tripIds: [String]
    
    private enum FirebaseAdapterUserKeys: String, CodingKey {
        case id
        case name
        case email
        case userId
        case tripIds
    }
    
    // TODO: Clean up / Merge with Firebase AdaptedTrip
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FirebaseAdapterUserKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.tripIds = try container.decode(Array.self, forKey: .tripIds)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FirebaseAdapterUserKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(userId, forKey: .userId)
        try container.encode(tripIds, forKey: .tripIds)
    }
}
