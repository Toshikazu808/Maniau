//
//  UserLogin.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import Foundation

struct UserLogin: Codable {
   let email: String
   let pw: String
   init(_ email: String, _ pw: String) {
      self.email = email
      self.pw = pw
   }
}
