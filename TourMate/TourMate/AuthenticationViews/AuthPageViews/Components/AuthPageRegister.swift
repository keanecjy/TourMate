//
//  RegisterForm.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct AuthPageRegister: View {
    let authenticationController = AuthenticationController()

    @State var email = ""
    @State var displayName = ""
    @State var password = ""
    @State var confirmPassword = ""

    @Binding var pageIsDisabled: Bool

    var containerSize: CGSize
    var generateOnPress: (@escaping () async -> (Bool, String)) -> (() async -> Void)

    var registerButtonDisabled: Bool {
        email.isEmpty || password.isEmpty || confirmPassword.isEmpty || pageIsDisabled
    }

    var opacity: Double {
        if pageIsDisabled {
            return 0.5
        }
        return 1.0
    }

    var body: some View {
        VStack(alignment: .center, spacing: containerSize.height / 80.0) {

            InputTextField(title: "Email *", textField: $email)

            InputTextField(title: "Display Name", textField: $displayName)

            InputSecureField(title: "Password *", textField: $password)

            InputSecureField(title: "Confirm Password *", textField: $confirmPassword)

            AuthPageSubmitButton(onPress: generateOnPress(register),
                                 title: "Register",
                                 maxWidth: containerSize.width / 5.0,
                                 isDisabled: registerButtonDisabled)

        }
        .frame(maxWidth: containerSize.width / 2.0)
        .disabled(pageIsDisabled)
        .opacity(opacity)
    }

    private func register() async -> (Bool, String) {
        let inputEmail = email
        let inputDisplayName = displayName
        let inputPassword = password
        let inputConfirmPassword = confirmPassword

        guard inputPassword == inputConfirmPassword else {
            return (false, "Passwords do not match")
        }

        let (hasRegistered, errorMessage) = await authenticationController.register(email: inputEmail,
                                                                                    password: inputPassword,
                                                                                    displayName: inputDisplayName)

        return (hasRegistered, errorMessage)
    }
}

// struct RegisterForm_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterForm()
//    }
// }
