//
//  LogInView.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import SwiftUI

struct LogInView: View {
    let authenticationController = AuthenticationController()

    @State var email = ""
    @State var password = ""
    @State var pageIsDisabled = false

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
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()

                TitleView()

                Spacer()

                VStack(alignment: .center, spacing: geometry.size.height / 100.0) {

                    InputTextField(title: "Email", textField: $email)

                    InputSecureField(title: "Password", textField: $password)

                    SubmitButton(onPress: onLogInButtonPressed,
                                 title: "Log In",
                                 maxWidth: geometry.size.width / 5.0,
                                 isDisabled: logInButtonDisabled)
                }
                .frame(maxWidth: geometry.size.width / 2.0)
                .disabled(pageIsDisabled)
                .opacity(opacity)

                if pageIsDisabled {
                    ProgressView("Logging In...")
                        .padding()
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func onLogInButtonPressed() {
        // Removes focus on Textfields and closes keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        guard self.pageIsDisabled == false else {
            return
        }

        self.pageIsDisabled = true
        let inputEmail = email
        let inputPassword = password

        authenticationController.logIn(email: inputEmail, password: inputPassword)

        self.pageIsDisabled = false
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
