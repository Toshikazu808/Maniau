//
//  Utilities.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit

struct Utilities {
   static func validateFields(_ email: String, _ password: String) -> String? {
      if email == "" {
         return "Please enter your email."
      }
      if password == "" {
         return "Please enter a password"
      }
      return nil
   }
   
   static func extractEmail(from data: String) -> String {
      var email = data
      for char in email {
         if char == " " {
            email.removeFirst()
            break
         }
         email.removeFirst()
      }
      email.removeLast()
      return email
   }
}
