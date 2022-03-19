//
//  SettingsView.swift
//  TourMate
//
//  Created by Terence Ho on 17/3/22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()

                Text("Settings")
                    .font(.largeTitle)

                LogOutView(containerSize: geometry.size)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
