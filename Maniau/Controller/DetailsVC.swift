//
//  DetailsVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/9/21.
//

import UIKit
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
      print(#function)
      self.tabBarController?.tabBar.isHidden = true
      setupLabels()
      setupBackgroundUI()
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.destination is AddVC {
         let vc = segue.destination as? AddVC
         vc?.updateItem = true
         vc?.prefillTF = titleLabel.text ?? ""
      }
   }
   
   private func setupLabels() {
      if let schedule = schedule {
         titleLabel.text = schedule.title
         self.selections = schedule.convertToDetailsArray()
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
      Firestore.firestore().collection(id!).document(schedule!.title).delete { [weak self] err in
         if let err = err {
            self?.showError(err.localizedDescription)
         } else {
            print("Successfully deleted document")
            self?.delegate?.deleteAndUpdate()
            self?.navigationController?.popViewController(animated: true)
         }
      }
   }
}
