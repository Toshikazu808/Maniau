//
//  MonthTabCell.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

class MonthTabCell: UITableViewCell {
   static let name: String = "MonthTabCell"
   @IBOutlet weak var colorView: UIView!
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var descriptionLabel: UILabel!
   @IBOutlet weak var startLabel: UILabel!
   @IBOutlet weak var endLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      colorView.layer.cornerRadius = 3
      colorView.backgroundColor = .systemTeal
   }
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func configure(color: String, title: String, details: String, start: String, end: String) {
      colorView.backgroundColor = convertColorString(color)
      titleLabel.text = title
      descriptionLabel.text = details
      startLabel.text = start
      endLabel.text = end
   }
   
   private func convertColorString(_ color: String) -> UIColor {
      switch color {
      case "Blue":
         return UIColor.systemBlue
      case "Teal":
         return UIColor.systemTeal
      case "Green":
         return UIColor.systemGreen
      case "Orange":
         return UIColor.systemOrange
      case "Red":
         return UIColor.systemRed
      case "Yellow":
         return UIColor.systemYellow
      case "Gray":
         return UIColor.systemGray
      default:
         return UIColor.systemTeal
      }
   }
   
}
