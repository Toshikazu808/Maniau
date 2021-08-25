//
//  Defaults.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import Foundation

struct Defaults {
   static let autoLogin = UserDefaults.standard
   static let autoLoginKey = "SaveAutoLogin"
   
   static let userInfo = UserDefaults.standard
   static let userInfoKey = "SavedUserInfo"
   
   static let notifications = UserDefaults.standard
   static let notificationsKey = "SavedNotifications"
}
