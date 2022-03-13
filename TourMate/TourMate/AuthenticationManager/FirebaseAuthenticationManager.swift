//
//  FirebaseAuthenticationManager.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import Foundation
import FirebaseAuth

// https://peterfriese.dev/posts/firebase-async-calls-swift/
struct FirebaseAuthenticationManager: AuthenticationManager {

    @MainActor
    func registerUser(email: String, password: String) async -> (hasRegistered: Bool, errorMessage: String) {
        guard isValidEmail(email) else {
            return (false, "Invalid Email")
        }

        var hasRegistered = false
        var errorMessage = ""

        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            hasRegistered = true
        } catch {
            let errorCode = AuthErrorCode(rawValue: error._code)
            switch errorCode {
            case .invalidEmail:
                errorMessage = "Invalid Email or Password"
            case .emailAlreadyInUse:
                errorMessage = "Email is already in use"
            case .weakPassword:
                errorMessage = "Password is too weak. Please use a stronger password"
            default:
                errorMessage = "Unable to register, please try again later"
            }
            print(error)
        }

        return (hasRegistered, errorMessage)
    }

    @MainActor
    func logInUser(email: String, password: String) async -> (hasLoggedIn: Bool, errorMessage: String) {
        guard isValidEmail(email) else {
            return (false, "Invalid Email")
        }

        var hasLoggedIn = false
        var errorMessage = ""

        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            hasLoggedIn = true
        } catch {
            let errorCode = AuthErrorCode(rawValue: error._code)
            switch errorCode {
            case .userNotFound, .invalidEmail, .wrongPassword:
                errorMessage = "Invalid Email or Password"
            case .userDisabled:
                errorMessage = "User Account is disabled"
            default:
                errorMessage = "Unable to log in, please try again later"
            }
            print(error)
        }

        return (hasLoggedIn, errorMessage)
    }

    @MainActor
    func logOutUser() async -> (hasLoggedOut: Bool, errorMessage: String) {
        var hasLoggedOut = false
        var errorMessage = ""

        do {
            try Auth.auth().signOut()
            hasLoggedOut = true
        } catch {
            errorMessage = "Unable to log out, please try again later"
            print(error)
        }

        return (hasLoggedOut, errorMessage)
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
