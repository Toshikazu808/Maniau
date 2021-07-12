//
//  RepeatAlertTableVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

protocol SelectRepeatVCDelegate {
   func setRepeat(_ repeatSelection: String)
}

class SelectRepeatVC: UIViewController {
   var delegate: SelectRepeatVCDelegate?
   @IBOutlet private var selectedImages: [UIImageView]! // ORDER MATTERS
   private var repeatSelection: [TableItem] = [
      TableItem("Never", true),
      TableItem("Every Day", false),
      TableItem("Every Week", false),
      TableItem("Every 2 Weeks", false),
      TableItem("Every Month", false),
      TableItem("Every Year", false)
   ]
   private var selectedIndex = 0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.tabBarController?.tabBar.isHidden = true
      for i in 0..<repeatSelection.count {
         if repeatSelection[i].isSelected {
            selectedImages[i].alpha = 1
         } else {
            selectedImages[i].alpha = 0
         }
      }
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   @IBAction private func saveTapped(_ sender: UIBarButtonItem) {
      for i in 0..<repeatSelection.count {
         if !repeatSelection[i].isSelected {
            continue
         } else {
            delegate?.setRepeat(repeatSelection[i].label)
         }
      }
      self.navigationController?.popViewController(animated: true)
   }
   
   @IBAction private func cellTapped(_ sender: UIButton) {
      repeatSelection[sender.tag].isSelected = true
      selectedImages[sender.tag].alpha = 1
      
      for i in 0..<repeatSelection.count {
         if i == sender.tag {
            continue
         }
         repeatSelection[i].isSelected = false
         selectedImages[i].alpha = 0
      }
   }
}

