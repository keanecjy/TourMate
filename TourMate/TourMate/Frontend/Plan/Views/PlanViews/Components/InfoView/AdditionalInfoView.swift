//
//  AdditionalInfoView.swift
//  TourMate
//
//  Created by Terence Ho on 2/4/22.
//

import SwiftUI

struct AdditionalInfoView: View {
    @Environment(\.dismiss) var dismiss

    let additionalInfo: String

    var body: some View {
        NavigationView {
            Group {
                Text(additionalInfo)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .navigationTitle("Additional Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", role: .destructive) {
                        dismiss()
                    }
                }
            }
        }
    }
}

// struct AdditionalInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdditionalInfoView()
//    }
// }
