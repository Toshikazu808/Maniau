//
//  DetailsVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/9/21.
//

import UIKit
import UserNotifications
import FirebaseFirestore
import FirebaseAuth

protocol DetailsVCDelegate {
   func deleteAndUpdate()
}

class DetailsVC: UIViewController {
   var delegate: DetailsVCDelegate?
   var schedule: ScheduledEvent?
   @IBOutlet private weak var titleLabel: UILabel!
   @IBOutlet private weak var background: UIView!
   @IBOutlet private weak var confirmLabel: UILabel!
   @IBOutlet private weak var confirmDelete: UIButton!
   @IBOutlet private var details: [UILabel]!
   private var selections: [String] = ["", "", "", "", "", ""]
   private let db = Firestore.firestore()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupLabels()
      setupBackgroundUI()
   }
   override func viewWillAppear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = true
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.destination is AddVC {
         let vc = segue.destination as? AddVC
         vc?.updateItem = true
         if let schedule = schedule {
            vc?.oldId = schedule.id
            vc?.event.title = schedule.title
            vc?.event.description = schedule.description
            vc?.event.startTime = schedule.startTime
            vc?.event.endTime = schedule.endTime
            vc?.event.repeats = schedule.repeats
            vc?.event.relevantMonth = schedule.relevantMonth
            vc?.event.date = schedule.date
            vc?.event.selectedDay = schedule.selectedDay
            vc?.event.dayOfWeek = schedule.dayOfWeek
            vc?.event.color = schedule.color
         }
      }
   }
   
   private func setupLabels() {
      if let schedule = schedule {
         titleLabel.text = schedule.title
         selections = schedule.convertToDetailsArray()
      }
      for i in 0..<selections.count {
         details[i].text = selections[i]
      }
   }
   
   private func setupBackgroundUI() {
      let tapBackground = UITapGestureRecognizer(
         target: self,
         action: #selector(backgroundTapped))
      background.addGestureRecognizer(tapBackground)
      confirmDelete.layer.cornerRadius = 18
      confirmDelete.layer.borderColor = UIColor.white.cgColor
      confirmDelete.layer.borderWidth = 1.5
   }
   
   @IBAction private func deleteTapped(_ sender: UIButton) {
      Animations.fadeInViews(
         background: background,
         views: [confirmLabel, confirmDelete],
         collection: nil)
   }
   
   @objc private func backgroundTapped() {
      Animations.fadeOutViews(
         background: background,
         views: [confirmLabel, confirmDelete],
         collection: nil)
   }
   
   @IBAction func confirmDeleteTapped(_ sender: UIButton) {
      let id = Auth.auth().currentUser?.uid
      Firestore.firestore().collection(id!).document(schedule!.id).delete { [weak self] err in
         guard let self = self else { return }
         if let err = err {
            self.showError(err.localizedDescription)
         } else {
            print("Successfully deleted document")
            K.thisMonthsSchedule = K.thisMonthsSchedule.filter { $0.id != self.schedule!.id }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.schedule!.id])
            self.delegate?.deleteAndUpdate()
            DispatchQueue.main.async {
               self.navigationController?.popViewController(animated: true)
            }            
         }
      }
   }
}
