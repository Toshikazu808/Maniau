//
//  HomeVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import FirebaseAuth
import FSCalendar
import Firebase

class HomeVC: UIViewController {
   @IBOutlet weak var calendar: FSCalendar!
   @IBOutlet weak var tableView: UITableView!
   private let firebaseAuth = Auth.auth()
   private let db = Firestore.firestore()
   
   private let formatter = DateFormatter()
   private let dateDays = Calendar.current.dateComponents([.day],
      from: Calendar.current.dateInterval(of: .month, for: Date())!.start,
      to: Calendar.current.dateInterval(of: .month, for: Date())!.end)
   
   private var daysInMonth: String {
      var days = "\(dateDays)"
      var num = ""
      for char in days {
         if char == " " {
            days.removeFirst()
            break
         }
         days.removeFirst()
      }
      for char in days {
         if char != " " {
            num += "\(char)"
         } else {
            break
         }
      }
      return num
   }
   private var scheduleItems: [ScheduledEvent] = []
   
   override func viewDidLoad() {
      super.viewDidLoad()
      formatter.dateFormat = "EEEE MM-dd-YYYY"
      calendar.delegate = self
      print("days as string: \(daysInMonth)")
      loadFromFirebase()
   }
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destination = segue.destination as? AddVC {
         destination.delegate = self
      }
   }
   
   @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
      do {
         try firebaseAuth.signOut()
         print("Signed out user")
         Defaults.autoLogin.removeObject(forKey: Defaults.autoLoginKey)
         Defaults.autoLogin.setValue(false, forKey: Defaults.autoLoginKey)
         self.dismiss(animated: true, completion: nil)
      } catch let signOutError as NSError {
         print ("Error signing out: \(signOutError)")
      }
   }
   
   private func loadFromFirebase() {
      db.collection(K.fbUsers).order(by: "date").addSnapshotListener { [weak self] querySnapshot, error in
         self?.scheduleItems = []
         if let err = error {
            print(err)
         } else {
            if let snapshotDocuments = querySnapshot?.documents {
               for doc in snapshotDocuments {
                  let data = doc.data()
                  if let item = data[K.schedule] as? String {
                     
                  }
               }
            }
         }
      }
      
//      let doc = db.collection(K.fbUsers).document(id!)
//      doc.getDocument { [weak self] document, error in
//         if let document = document, document.exists {
//            let data = document.data().map(String.init(describing:)) ?? "nil"
//            print("data: \(data)")
//
//         }
//      }
   }
   
}

extension HomeVC: FSCalendarDelegate {
   func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      let dateString = formatter.string(from: date)
      print(dateString)
   }
}

extension HomeVC: AddVCDelegate {
   func updateScheduleTable(scheduleAdded: Bool) {
      if scheduleAdded {
//         tableView.reloadData()
         
         
      }
   }
}

//extension HomeVC: UITableViewDelegate, UITableViewDataSource {
//   func numberOfSections(in tableView: UITableView) -> Int {
//      <#code#>
//   }
//
//   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//      <#code#>
//   }
//
//   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//      <#code#>
//   }
//
//   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//      <#code#>
//   }
//
//   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      <#code#>
//   }
//
//}
