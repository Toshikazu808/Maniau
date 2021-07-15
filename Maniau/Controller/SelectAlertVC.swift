//
//  SelectAlertVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/24/21.
//

import UIKit

protocol SelectAlertVCDelegate {
   func setAlert(_ alertSelection: String)
}

class SelectAlertVC: UIViewController {
   var delegate: SelectAlertVCDelegate?
   @IBOutlet private var selectedImages: [UIImageView]! // ORDER MATTERS
   private var alertSelection: [TableItem] = [
      TableItem("None", true),
      TableItem("At time of event", false),
      TableItem("5 minutes before", false),
      TableItem("10 minutes before", false),
      TableItem("15 minutes before", false),
      TableItem("30 minutes before", false),
      TableItem("1 hour before", false),
      TableItem("2 hours before", false),
      TableItem("1 day before", false),
      TableItem("2 days before", false),
      TableItem("1 week before", false)
   ]
   private var selectedIndex = 0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      for i in 0..<alertSelection.count {
         if alertSelection[i].isSelected {
            selectedImages[i].alpha = 1
         } else {
            selectedImages[i].alpha = 0
         }
      }
   }
   override func viewWillAppear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = true
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   @IBAction private func saveTapped(_ sender: UIBarButtonItem) {
      for i in 0..<alertSelection.count {
         if !alertSelection[i].isSelected {
            continue
         } else {
            delegate?.setAlert(alertSelection[i].label)
         }
      }
      self.navigationController?.popViewController(animated: true)
   }
   
   @IBAction private func cellTapped(_ sender: UIButton) {
      alertSelection[sender.tag].isSelected = true
      selectedImages[sender.tag].alpha = 1
      for i in 0..<alertSelection.count {
         if i == sender.tag {
            continue
         }
         alertSelection[i].isSelected = false
         selectedImages[i].alpha = 0
      }
   }
}
