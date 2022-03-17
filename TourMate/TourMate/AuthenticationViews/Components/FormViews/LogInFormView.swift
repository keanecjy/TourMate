//
//  LogInForm.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct LogInFormView: View {
    let authenticationController = AuthenticationController.singleton

    @State var email = ""
    @State var password = ""

    @Binding var pageIsDisabled: Bool

    var containerSize: CGSize
    var generateOnPress: (@escaping () async -> (Bool, String)) -> (() async -> Void)

    var logInButtonDisabled: Bool {
        email.isEmpty || password.isEmpty || pageIsDisabled
    }

    var opacity: Double {
        if pageIsDisabled {
            return 0.5
        }
        return 1.0
    }

    var body: some View {
        VStack(alignment: .center, spacing: containerSize.height / 100.0) {

            InputTextField(title: "Email", textField: $email)

            InputSecureField(title: "Password", textField: $password)

            AuthenticationSubmitButton(onPress: generateOnPress(logInAuthAction),
                                       title: "Log In",
                                       maxWidth: containerSize.width / 5.0,
                                       isDisabled: logInButtonDisabled)
        }
        .frame(maxWidth: containerSize.width / 2.0)
        .disabled(pageIsDisabled)
        .opacity(opacity)
    }

    private func logInAuthAction() async -> (Bool, String) {
        let inputEmail = email
        let inputPassword = password

        let (hasLoggedIn, errorMessage) = await authenticationController.logIn(email: inputEmail,
                                                                               password: inputPassword)

        return (hasLoggedIn, errorMessage)
    }
}

// struct LogInForm_Previews: PreviewProvider {
//    static var previews: some View {
//        LogInForm()
//    }
// }
