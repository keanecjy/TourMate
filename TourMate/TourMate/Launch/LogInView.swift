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
    @State var showWarning = false
    @State var warningMessage = ""

    @State var hasLoggedIn = false
    @StateObject private var model = MockModel()

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

                if showWarning {
                    Text(warningMessage)
                        .foregroundColor(.red)
                }

                if pageIsDisabled {
                    ProgressView("Logging In...")
                        .padding()
                }

                Spacer()

                NavigationLink(isActive: $hasLoggedIn) {
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

    private func onLogInButtonPressed() async {
        // Removes focus on Textfields and closes keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        guard self.pageIsDisabled == false else {
            return
        }
        self.warningMessage = ""
        self.showWarning = false
        self.pageIsDisabled = true

        let inputEmail = email
        let inputPassword = password

        let (hasLoggedIn, errorMessage) = await authenticationController.logIn(email: inputEmail,
                                                                               password: inputPassword)

        guard hasLoggedIn else {
            self.warningMessage = errorMessage
            self.showWarning = true
            self.pageIsDisabled = false
            return
        }

        self.hasLoggedIn = true
        self.pageIsDisabled = false
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
