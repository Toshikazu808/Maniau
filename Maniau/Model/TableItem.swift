//
//  SelectRepeatModel.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/25/21.
//

import Foundation

struct TableItem {
   let label: String
   var isSelected: Bool
   init(_ label: String, _ isSelected: Bool) {
      self.label = label
      self.isSelected = isSelected
   }
}
