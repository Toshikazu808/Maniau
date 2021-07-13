//
//  DetailsVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 7/9/21.
//

import UIKit

protocol DetailsVCDelegate {
   func deleteAndUpdate()
}

class DetailsVC: UIViewController {
   var delegate: DetailsVCDelegate?
   var schedule: ScheduledEvent?
   @IBOutlet private weak var titleLabel: UILabel!
   @IBOutlet private weak var tableView: UITableView!
   @IBOutlet private weak var background: UIView!
   @IBOutlet private weak var confirmLabel: UILabel!
   @IBOutlet private weak var confirmDelete: UIButton!
   
   private let titles: [String] = [
      "Date:", "Start:", "End:", "Repeat:", "Alert:", "Color:"]
   private var selections: [String] = ["", "", "", "", "", ""]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      print(#function)
      self.tabBarController?.tabBar.isHidden = true
      if let schedule = schedule {
         titleLabel.text = schedule.title
         selections = [
            schedule.date,
            schedule.startTime,
            schedule.endTime,
            schedule.repeats,
            schedule.alert,
            schedule.color]
      }
      print("")
      tableView.backgroundColor = .clear
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: EventDetailsCell.name, bundle: nil), forCellReuseIdentifier: EventDetailsCell.name)
      let tapBackground = UITapGestureRecognizer(
         target: self,
         action: #selector(backgroundTapped))
      background.addGestureRecognizer(tapBackground)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.destination is AddVC {
         let vc = segue.destination as? AddVC
         vc?.updateItem = true
         vc?.prefillTF = titleLabel.text ?? ""
      }
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
      // update Firestore
      
   }
}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return titles.count
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      UITableView.automaticDimension
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
         withIdentifier: EventDetailsCell.name,
         for: indexPath) as! EventDetailsCell
      cell.configure(
         label: titles[indexPath.row],
         selection: selections[indexPath.row])
      return cell
   }
}
