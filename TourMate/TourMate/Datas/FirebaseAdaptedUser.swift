//
//  User.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseFirestoreSwift

struct FirebaseAdaptedUser: Codable {
    init(id: String, name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    @DocumentID var id: String?
    let name: String
    let email: String
    let password: String

    private enum FirebaseAdapterUserKeys: String, CodingKey {
        case id
        case name
        case email
        case password
    }

    // TODO: Clean up / Merge with Firebase AdaptedTrip
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FirebaseAdapterUserKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.password = try container.decode(String.self, forKey: .password)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FirebaseAdapterUserKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
}
