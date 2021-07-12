//
//  EventDetailsCell.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/9/21.
//

import UIKit

class EventDetailsCell: UITableViewCell {
   static let name = "EventDetailsCell"
   @IBOutlet weak var background: UIView!
   @IBOutlet weak var label: UILabel!
   @IBOutlet weak var selection: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      background.backgroundColor = .clear
      label.textColor = .white
      selection.textColor = .white
      self.isUserInteractionEnabled = false
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func configure(label: String, selection: String) {
      self.label.text = label
      self.selection.text = selection
   }
}
