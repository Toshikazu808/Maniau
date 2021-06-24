//
//  AddVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit

class AddVC: UIViewController {
   @IBOutlet weak var titleTF: UITextField!
   @IBOutlet weak var descriptionTF: UITextField!
   @IBOutlet weak var allDay: UISwitch!
   @IBOutlet weak var dateBtn: UIButton!
   @IBOutlet weak var startBtn: UIButton!
   @IBOutlet weak var endBtn: UIButton!
   @IBOutlet weak var repeatBtn: UIButton!
   @IBOutlet weak var alertBtn: UIButton!
   
   let titlePlaceholder = "Title"
   let descriptionPlaceholder = "Description"
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   
}


extension AddVC: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      switch textField {
      case titleTF:
         titleTF.endEditing(true)
         return true
      case descriptionTF:
         descriptionTF.endEditing(true)
         return true
      default:
         return false
      }
   }
   
   func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      switch textField {
      case titleTF:
         if titleTF.text != "" {
            return true
         } else {
            titleTF.placeholder = titlePlaceholder
            return false
         }
      case descriptionTF:
         if descriptionTF.text != "" {
            return true
         } else {
            descriptionTF.placeholder = descriptionPlaceholder
            return false
         }
      default:
         return false
      }
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      switch textField {
      case titleTF:
         titleTF.text = ""
         titleTF.placeholder = titlePlaceholder
      case descriptionTF:
         descriptionTF.text = ""
         descriptionTF.placeholder = descriptionPlaceholder
      default:
         break
      }
   }
}


