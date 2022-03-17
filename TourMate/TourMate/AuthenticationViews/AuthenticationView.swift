//
//  AuthenticationView.swift
//  TourMate
//
//  Created by Terence Ho on 12/3/22.
//

import SwiftUI

struct AuthenticationView: View {
    @State var pageIsDisabled = false
    @State var warningMessage = ""

    let authType: AuthenticationType

    var progressMessage: String {
        if authType == .register {
            return "Registering..."
        } else {
            return "Logging In..."
        }
    }

    // Views where the actual log in and registration happens
    @ViewBuilder
    func generateForm(type: AuthenticationType, containerSize: CGSize) -> some View {
        switch type {
        case .logIn:
            LogInFormView(pageIsDisabled: $pageIsDisabled,
                          containerSize: containerSize,
                          generateOnPress: generateOnPress)
        case .register:
            RegisterFormView(pageIsDisabled: $pageIsDisabled,
                             containerSize: containerSize,
                             generateOnPress: generateOnPress)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()

                TourMateTitleView()

                Spacer()

                generateForm(type: authType, containerSize: geometry.size)

                AuthenticationStatusView(warningMessage: $warningMessage,
                                         pageIsDisabled: $pageIsDisabled,
                                         progressMessage: progressMessage)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func generateOnPress(authAction: @escaping () async -> (Bool, String)) -> (() async -> Void) {
        {
            guard setupOnButtonPressed() else {
                return
            }

            let (actionSuccess, errorMessage) = await authAction()

            tearDownOnButtonPressed(actionSuccess: actionSuccess, errorMessage: errorMessage)
        }
    }

    private func setupOnButtonPressed() -> Bool {
        // Removes focus on Textfields and closes keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        guard self.pageIsDisabled == false else {
            return false
        }

        setPageStatusDisplay(warningMessage: "", disablePage: true)
        return true
    }

    private func tearDownOnButtonPressed(actionSuccess: Bool, errorMessage: String) {
        guard actionSuccess else {
            setPageStatusDisplay(warningMessage: errorMessage, disablePage: false)
            return
        }

        setPageStatusDisplay(warningMessage: "", disablePage: false)
    }

    private func setPageStatusDisplay(warningMessage: String, disablePage: Bool) {
        self.warningMessage = warningMessage
        self.pageIsDisabled = disablePage
    }
}

// struct AuthenticationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthenticationView()
//    }
// }
