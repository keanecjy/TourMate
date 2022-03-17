//
//  RegisterTitleView.swift
//  TourMate
//
//  Created by Terence Ho on 17/3/22.
//

import SwiftUI

struct RegisterTitleView: View {
    var body: some View {
        Text("Don't have an account? Register here!")
            .foregroundColor(.blue)
            .underline()
    }
}

struct RegisterTitleView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterTitleView()
    }
}
