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
                    RegisterTitleView()
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
