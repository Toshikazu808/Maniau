//
//  Defaults.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import Foundation

struct Defaults {
   static var saveLogin: Bool = false
   static let saveLoginTracker = UserDefaults.standard
   static let saveLoginKey = "SaveAutoLogin"
   
   static let saveUserInfoTracker = UserDefaults.standard
   static let saveUserInfoKey = "SavedUserInfo"
}
