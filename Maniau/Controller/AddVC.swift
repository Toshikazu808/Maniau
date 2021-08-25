//
//  AddVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/23/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol AddVCDelegate {
   func updateScheduleTable()
}

class AddVC: UIViewController {
   var delegate: AddVCDelegate?
   @IBOutlet private weak var loadingView: UIView!
   @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
   
   var updateItem: Bool = false
   var prefillTF: String = ""
   @IBOutlet private weak var titleTF: UITextField!
   @IBOutlet private weak var descriptionTF: UITextField!
   @IBOutlet private weak var allDay: UISwitch!
   
   @IBOutlet private weak var datePicker: UIDatePicker!
   @IBOutlet private weak var startBtn: UIButton!
   @IBOutlet private weak var endBtn: UIButton!
   private var startWasTapped = false
   @IBOutlet private weak var repeatBtn: UIButton!
   @IBOutlet private weak var alertBtn: UIButton!
   @IBOutlet private weak var colorBtn: UIButton!
   
   @IBOutlet weak var pickerBackground: UIView!
   @IBOutlet weak var colorPickerView: UIView!
   @IBOutlet var colorButtons: [UIButton]!
   
   @IBOutlet private weak var pickerLabel: UILabel!
   @IBOutlet private weak var picker: UIPickerView!
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
      relevantMonth: "",
      date: Date().formatDate(),
      selectedDay: Date().getSelectedDay(),
      dayOfWeek: Date().formatDayOfWeek(),
      color: "Teal")
   private var scheduleAdded = false
   private var date = Date()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      selectRepeatVC.delegate = self
      selectAlertVC.delegate = self
      makePickerArrays()
      picker.delegate = self
      picker.dataSource = self
      datePicker.datePickerMode = .date
      let tapBackground = UITapGestureRecognizer(
         target: self,
         action: #selector(backgroundTapped))
      pickerBackground.addGestureRecognizer(tapBackground)
      colorBtn.layer.cornerRadius = 3
   }
   override func viewWillAppear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = true
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? SelectRepeatVC {
         destination.delegate = self
      } else if let destination = segue.destination as? SelectAlertVC {
         destination.delegate = self
      }
   }
   
   @IBAction private func saveTapped(_ sender: UIBarButtonItem) {
      if titleTF.text != "" {
         displayLoading(with: loadingView, and: loadingIndicator)
         event.title = titleTF.text!
         event.description = descriptionTF.text ?? ""
         event.startTime = startBtn.title(for: .normal) ?? "12:00 AM"
         event.endTime = endBtn.title(for: .normal) ?? "12:01 AM"
         event.relevantMonth = date.getRelevantMonth()
         attemptToSaveData()
      } else {
         showError("Please give your event a title")
      }
   }
   
   private func attemptToSaveData() {
      if !updateItem {
         saveSequence()
      } else {
         updateSequence()
      }
   }
   
   private func saveSequence() {
      let id = Auth.auth().currentUser?.uid
      Firestore.firestore().collection(id!).document(event.title).setData(Utilities.convertScheduleToDict(event), merge: true) { [weak self] err in
         guard let self = self else { return }
         if let err = err {
            self.showError(err.localizedDescription)
         } else {
            print("Successfully saved document")
            LocalNotificationManager.setNotification(for: self.event)
            self.delegate?.updateScheduleTable()
            self.navigationController?.popToRootViewController(animated: true)
         }
      }
   }
   
   private func updateSequence() {
      let id = Auth.auth().currentUser?.uid
      Firestore.firestore().collection(id!).document(event.title).setData(Utilities.convertScheduleToDict(event), merge: false) { [weak self] err in
         guard let self = self else { return }
         if let err = err {
            self.showError(err.localizedDescription)
         } else {
            print("Successfully updated document")
            self.delegate?.updateScheduleTable()
            // delete corresponding notification
            // save new local notification!
            self.navigationController?.popToRootViewController(animated: true)
         }
      }
   }
   
   @IBAction private func dateTapped(_ sender: UIDatePicker) {
      event.date = sender.date.formatDate()
      event.selectedDay = sender.date.getSelectedDay()
      event.dayOfWeek = sender.date.formatDayOfWeek()
      print("event.date: \(event.date)")
   }
   
   @IBAction private func displayPicker(_ sender: UIButton) {
      startWasTapped = sender.tag == 0 ? true : false
      pickerLabel.text = startWasTapped ? "Select Start Time" : "Select End Time"
      Animations.fadeInViews(
         background: pickerBackground,
         views: [pickerLabel, picker],
         collection: nil)
      pickerIsSelected = true
   }
      
   @IBAction private func colorTapped(_ sender: UIButton) {
      Animations.fadeInViews(
         background: pickerBackground,
         views: [colorPickerView],
         collection: colorButtons)
   }
   
   @objc private func backgroundTapped() {
      if pickerIsSelected {
         Animations.fadeOutViews(
            background: pickerBackground,
            views: [pickerLabel, picker],
            collection: nil)
         pickerIsSelected = false
      } else {
         Animations.fadeOutViews(
            background: pickerBackground,
            views: [colorPickerView],
            collection: colorButtons)
      }
   }
   
   @IBAction private func chosenColorTapped(_ sender: UIButton) {
      switch sender.tag {
      case 0:
         event.color = "Blue"
      case 1:
         event.color = "Teal"
      case 2:
         event.color = "Green"
      case 3:
         event.color = "Orange"
      case 4:
         event.color = "Red"
      case 5:
         event.color = "Yellow"
      case 6:
         event.color = "Gray"
      default:
         event.color = "Teal"
      }
      colorBtn.backgroundColor = Animations.convertColorString(event.color)
      Animations.fadeOutViews(
         background: pickerBackground,
         views: [colorPickerView],
         collection: colorButtons)
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
   func makePickerArrays() {
      for i in 1...12 {
         hrArray.append("\(i)")
      }
      for i in 0...60 {
         minArray.append("\(i)")
      }
   }
   
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
         time.min = Utilities.formatMinutes(num: row)
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
   }
}

extension AddVC: SelectAlertVCDelegate {
   func setAlert(_ alertSelection: String) {
      alertBtn.setTitle(alertSelection, for: .normal)
   }
}
