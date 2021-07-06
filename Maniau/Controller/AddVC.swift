//
//  AddVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit
import FirebaseFirestore

protocol AddVCDelegate {
   func updateScheduleTable(scheduleAdded: Bool)
}

class AddVC: UIViewController {
   var delegate: AddVCDelegate?
   @IBOutlet weak var titleTF: UITextField!
   @IBOutlet weak var descriptionTF: UITextField!
   @IBOutlet weak var allDay: UISwitch!
   
   @IBOutlet weak var datePicker: UIDatePicker!
   @IBOutlet weak var startBtn: UIButton!
   @IBOutlet weak var endBtn: UIButton!
   private var startWasTapped = false
   @IBOutlet weak var repeatBtn: UIButton!
   @IBOutlet weak var alertBtn: UIButton!
   
   @IBOutlet weak var pickerLabel: UILabel!
   @IBOutlet weak var picker: UIPickerView!
   private var pickerIsSelected = false
   private var hrArray: [String] = []
   private var minArray: [String] = []
   private var ampmArray: [String] = ["AM", "PM"]
   private var time: (hr: String, min: String, amPm: String) = ("1", "00", "AM")
   private var timeToTransfer: String {
      return "\(time.hr):\(time.min) \(time.amPm)"
   }
   
   private var selectRepeatVC = SelectRepeatVC()
   private var selectAlertVC = SelectAlertVC()
   private var event = ScheduledEvent(
      title: "",
      description: "",
      startTime: "4:00 PM",
      endTime: "5:00 PM",
      repeats: "Never",
      alert: "None",
      date: "Jun 24, 2021")
   private var formatter = DateFormatter()
   private var scheduleAdded = false
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.tabBarController?.tabBar.isHidden = true
      selectRepeatVC.delegate = self
      selectAlertVC.delegate = self
      pickerLabel.alpha = 0
      picker.alpha = 0
      makePickerArrays()
      picker.delegate = self
      picker.dataSource = self
      datePicker.datePickerMode = .date
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   private func makePickerArrays() {
      for i in 1...12 {
         hrArray.append("\(i)")
      }
      for i in 0...60 {
         minArray.append("\(i)")
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? SelectRepeatVC {
         destination.delegate = self
      } else if let destination = segue.destination as? SelectAlertVC {
         destination.delegate = self
      }
   }
   
   @IBAction func saveTapped(_ sender: UIBarButtonItem) {
      if titleTF.text != "" {
         event.title = titleTF.text!
         event.description = descriptionTF.text ?? ""
         Utilities.setAlert(for: event)
         if let err = Utilities.saveToFirebase(event) {
            self.showError(err.localizedDescription)
         }
         self.navigationController?.popViewController(animated: true)
      } else {
         showError("Please give your event a title")
      }
   }
   
   @IBAction func displayPicker(_ sender: UIButton) {
      startWasTapped = sender.tag == 0 ? true : false
      pickerLabel.text = startWasTapped ? "Select Start Time" : "Select End Time"
      if pickerIsSelected {
         UIView.animate(withDuration: 0.4) {
            self.pickerLabel.alpha = 0
            self.picker.alpha = 0
         }
      } else {
         UIView.animate(withDuration: 0.4) {
            self.pickerLabel.alpha = 1
            self.picker.alpha = 1
         }
      }
      pickerIsSelected = pickerIsSelected == true ? false : true
   }
   
   @IBAction func dateTapped(_ sender: UIDatePicker) {
      event.date = sender.date.formatDate()
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
}

extension AddVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
         time.hr = "\(row + 1)"
      case 1:
         time.min = Utilities.formatMinutes(num: row + 1)
      case 2:
         time.amPm = row == 0 ? "AM" : "PM"
      default:
         break
      }
      if startWasTapped {
         startBtn.setTitle(timeToTransfer, for: .normal)
      } else {
         endBtn.setTitle(timeToTransfer, for: .normal)
      }
   }
   
}

extension AddVC: SelectRepeatVCDelegate {
   func setRepeat(_ repeatSelection: String) {
      repeatBtn.setTitle(repeatSelection, for: .normal)
      // Set notification for selected interval
   }
}

extension AddVC: SelectAlertVCDelegate {
   func setAlert(_ alertSelection: String) {
      alertBtn.setTitle(alertSelection, for: .normal)
      // Set notification for selected date / time
   }
}



