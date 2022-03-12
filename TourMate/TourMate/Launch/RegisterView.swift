//
//  RegistrationView.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import SwiftUI

struct RegisterView: View {
    let authenticationController = AuthenticationController()

    @State var email = ""
    @State var displayName = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var pageIsDisabled = false
    @State var showWarning = false
    @State var warningMessage = ""

    @State var hasRegistered = false
    @StateObject private var model = MockModel()

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
        GeometryReader { geometry in
            VStack {
                Spacer()

                TitleView()

                Spacer()

                VStack(alignment: .center, spacing: geometry.size.height / 80.0) {

                    InputTextField(title: "Email *", textField: $email)

                    InputTextField(title: "Display Name", textField: $displayName)

                    InputSecureField(title: "Password *", textField: $password)

                    InputSecureField(title: "Confirm Password *", textField: $confirmPassword)

                    SubmitButton(onPress: onRegisterButtonPressed,
                                 title: "Register",
                                 maxWidth: geometry.size.width / 5.0,
                                 isDisabled: registerButtonDisabled)

                }
                .frame(maxWidth: geometry.size.width / 2.0)
                .disabled(pageIsDisabled)
                .opacity(opacity)

                if showWarning {
                    Text(warningMessage)
                        .foregroundColor(.red)
                }

                if pageIsDisabled {
                    ProgressView("Registering...")
                }

                Spacer()

                NavigationLink(isActive: $hasRegistered) {
                    ContentView()
                        .environmentObject(model)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func onRegisterButtonPressed() async {
        // Removes focus on Textfields and closes keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        guard self.pageIsDisabled == false else {
            return
        }

        self.warningMessage = ""
        self.showWarning = false
        self.pageIsDisabled = true

        let inputEmail = email
        let inputDisplayName = displayName
        let inputPassword = password
        let inputConfirmPassword = confirmPassword

        guard inputPassword == inputConfirmPassword else {
            self.warningMessage = "Passwords do not match"
            self.showWarning = true
            self.pageIsDisabled = false
            return
        }

        let (hasRegistered, errorMessage) = await authenticationController.register(email: inputEmail,
                                                                                    password: inputPassword,
                                                                                    displayName: inputDisplayName)

        guard hasRegistered else {
            self.warningMessage = errorMessage
            self.showWarning = true
            self.pageIsDisabled = false
            return
        }

        self.hasRegistered = true
        self.pageIsDisabled = false
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
