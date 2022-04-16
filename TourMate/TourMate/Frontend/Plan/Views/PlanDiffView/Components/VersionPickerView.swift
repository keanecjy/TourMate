//
//  VersionPickerView.swift
//  TourMate
//
//  Created by Keane Chan on 16/4/22.
//

import SwiftUI

struct VersionPickerView: View {
    @Binding var selectedVersion: Int

    var onVersionChange: (Int) -> Void

    var versionNumbers: [Int]

    internal init(selectedVersion: Binding<Int>, onChange: @escaping (Int) -> Void, versionNumbers: [Int]) {
        self._selectedVersion = selectedVersion
        self.onVersionChange = onChange
        self.versionNumbers = versionNumbers
    }

    var body: some View {
        Picker("Version", selection: $selectedVersion) {
            ForEach(versionNumbers, id: \.self) { num in
                Text("Version: \(String(num))").tag(num)
            }
        }
        .pickerStyle(.menu)
        .padding([.horizontal])
        .background(
            Capsule().fill(Color.primary.opacity(0.25))
        )
        .onChange(of: selectedVersion, perform: { val in
            onVersionChange(val)
        })

    }
}
