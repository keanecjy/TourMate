//
//  LaunchView.swift
//  TourMate
//
//  Created by Terence Ho on 8/3/22.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Spacer()

                    TourMateTitleView()

                    Spacer()

                    NavigationLink {
                        AuthenticationView(authType: .logIn)
                    } label: {
                        LogInTitleView(maxWidth: geometry.size.width / 5.0)
                    }

                    NavigationLink {
                        AuthenticationView(authType: .register)
                    } label: {
                        Text("Don't have an account? Register here!")
                            .foregroundColor(.blue)
                            .underline()
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
