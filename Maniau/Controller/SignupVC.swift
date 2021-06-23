//
//  SignupVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignupVC: UIViewController {
   @IBOutlet weak var signupView: UIView!
   @IBOutlet weak var emailTextfield: UITextField!
   @IBOutlet weak var pwTextfield: UITextField!
   @IBOutlet weak var signupBtn: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      signupView.layer.cornerRadius = 6
      signupBtn.layer.cornerRadius = 15
   }
   
   @IBAction func signupTapped(_ sender: UIButton) {
      let email = emailTextfield.text ?? ""
      let pw = pwTextfield.text ?? ""
      let textfieldError = Utilities.validateFields(email, pw)
      if textfieldError != nil {
         showError(textfieldError!)
      } else {
         createUser(email, pw)
      }
   }
   
   private func createUser(_ email: String, _ pw: String) {
      Auth.auth().createUser(withEmail: email, password: pw) { [weak self] result, err in
         if let err = err {
            self?.showError(err.localizedDescription)
            print(err)
         } else {
            print("User created successfully")
            User.email = email
            let db = Firestore.firestore()
            db.collection(K.fbUsers).document(result!.user.uid).setData([
               "email": email
            ]) { err in
               if let err = err {
                  print("Error writing document: \(err)")
               } else {
                  print("Document successfully written!")
               }
            }
            self?.clearTextFields(self!.emailTextfield, self!.pwTextfield)
            self?.transitionToHome()
         }
      }
   }
   
   private func transitionToHome() {
      let homeVC = storyboard?.instantiateViewController(identifier: K.homeVC)
      self.navigationController?.pushViewController(homeVC!, animated: true)
   }
}
