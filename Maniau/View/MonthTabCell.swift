//
//  MonthTabCell.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

class MonthTabCell: UITableViewCell {
   static let name: String = "MonthTabCell"
   @IBOutlet private weak var colorView: UIView!
   @IBOutlet private weak var titleLabel: UILabel!
   @IBOutlet private weak var descriptionLabel: UILabel!
   @IBOutlet private weak var startLabel: UILabel!
   @IBOutlet private weak var endLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      colorView.layer.cornerRadius = 4
      colorView.backgroundColor = .systemTeal
   }
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func configure(color: String, title: String, details: String, start: String, end: String) {
      colorView.backgroundColor = Animations.convertColorString(color)
      titleLabel.text = title
      descriptionLabel.text = details
      startLabel.text = start
      endLabel.text = end
   }   
}
