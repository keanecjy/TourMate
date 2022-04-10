//
//  AuthenticationDelegate.swift
//  TourMate
//
//  Created by Terence Ho on 10/4/22.
//

import Foundation

protocol AuthenticationManagerDelegate: AnyObject {
    func update(isLoggedIn: Bool)
}
