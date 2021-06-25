//
//  SelectEndTimeVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/24/21.
//

import UIKit

protocol SelectEndTimeVCDelegate {
   func updateEndTime(time: String)
}

class SelectEndTimeVC: UIViewController {
   var delegate: SelectEndTimeVCDelegate?
   @IBOutlet weak var pickerView: UIPickerView!
   private var hrArray: [String] = []
   private var minArray: [String] = []
   private let ampmArray: [String] = ["AM", "PM"]
   private var time: (hr: String, min: String, amPm: String) = ("1", "0", "AM")
   private var timeToTransfer: String {
      return "\(time.hr):\(time.min) \(time.amPm)"
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      super.viewDidLoad()
      for i in 1...12 {
         hrArray.append("\(i)")
      }
      for i in 0...60 {
         minArray.append("\(i)")
      }
      pickerView.delegate = self
      pickerView.dataSource = self
   }
   
   @IBAction func saveTapped(_ sender: UIBarButtonItem) {
      
   }
   
   
}


extension SelectEndTimeVC: UIPickerViewDelegate, UIPickerViewDataSource {
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 3
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch component {
      case 0:
         return hrArray.count
      case 1:
         return minArray.count
      case 2:
         return ampmArray.count
      default:
         return NSNotFound
      }
   }
   
   func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
      var attributedString: NSAttributedString!
      switch component {
      case 0:
         attributedString = NSAttributedString(string: hrArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
      case 1:
         attributedString = NSAttributedString(string: minArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
      case 2:
         attributedString = NSAttributedString(string: ampmArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
      default:
         attributedString = nil
      }
      return attributedString
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch component {
      case 0:
         time.hr = "\(row)"
      case 1:
         time.min = "\(row)"
      case 2:
         if row == 0 {
            time.amPm = "AM"
         } else {
            time.amPm = "PM"
         }
      default:
         break
      }
   }
   
}
