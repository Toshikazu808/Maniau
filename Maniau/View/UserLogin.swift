//
//  UserLogin.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import Foundation

struct UserLogin: Codable {
   let email: String
   init(_ email: String) {
      self.email = email
   }
}
