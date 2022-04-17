//
//  StringExtension.swift
//  TourMate
//
//  Created by Rayner Lim on 17/4/22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
