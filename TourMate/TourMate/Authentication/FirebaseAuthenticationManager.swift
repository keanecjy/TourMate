//
//  FirebaseAuthenticationManager.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthenticationManager: AuthenticationManager {
    @MainActor
    func registerUser(email: String, password: String) async -> (hasRegistered: Bool, errorMessage: String) {
        guard isValidEmail(email) else {
            return (false, "Invalid Email")
        }

        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return (true, "")
        } catch {
            let errorMessage = error.localizedDescription
            return (false, errorMessage)
        }
    }

    func logInUser(email: String, password: String) async -> (hasRegistered: Bool, errorMessage: String) {
        (true, "")
    }

    // https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    func isValidEmail(_ email: String) -> Bool {
        do {
            // swiftlint:disable:next line_length
            let pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let match = regex.firstMatch(in: email.self, options: [], range: NSRange(location: 0, length: email.count))
            return match != nil
        } catch {
            return false
        }
    }
}
