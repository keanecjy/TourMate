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

    var labels: [Int: String]

    internal init(selectedVersion: Binding<Int>, onChange: @escaping (Int) -> Void, versionNumbers: [Int]) {
        self._selectedVersion = selectedVersion
        self.onVersionChange = onChange
        self.versionNumbers = versionNumbers
        self.labels = [:]

        for versionNumber in versionNumbers {
            labels[versionNumber] = String(versionNumber)
        }
    }

    init(selectedVersion: Binding<Int>, onChange: @escaping (Int) -> Void, versionNumbers: [Int], labels: [Int: String]) {
        self._selectedVersion = selectedVersion
        self.onVersionChange = onChange
        self.versionNumbers = versionNumbers
        self.labels = labels
    }

    var body: some View {
        Picker("Version", selection: $selectedVersion) {
            ForEach(versionNumbers, id: \.self) { num in
                Text("Version: \(self.labels[num] ?? String(num))").tag(num)
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
