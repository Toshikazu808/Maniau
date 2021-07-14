//
//  SignupVC.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupVC: UIViewController {
   @IBOutlet private weak var signupView: UIView!
   @IBOutlet private weak var emailTextfield: UITextField!
   @IBOutlet private weak var pwTextfield: UITextField!
   @IBOutlet private weak var signupBtn: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      signupView.layer.cornerRadius = 6
      signupBtn.layer.cornerRadius = 15
      emailTextfield.delegate = self
      pwTextfield.delegate = self
   }
   
   @IBAction func backTapped(_ sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
   @IBAction func signupTapped(_ sender: UIButton) {
      let email = emailTextfield.text ?? ""
      let pw = pwTextfield.text ?? ""
      let err = validateFields(email, pw)
      if let err = err {
         showError(err)
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
            self?.saveUserEmailToDefaults(email)
            let userID = result!.user.uid
            self?.initUserDocument(userID, email)
            self?.clearLoginTextFields(self!.emailTextfield, self!.pwTextfield)
            self?.transitionToHome(email)
         }
      }
   }
   
   private func initUserDocument(_ uid: String, _ email: String) {
      let db = Firestore.firestore()
      db.collection(uid).document(uid).setData(["email": email]) { err in
         if let err = err {
            print("Error writing email document: \(err)")
         } else {
            print("Email document successfully written!")
         }
      }
   }
}

extension SignupVC: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      switch textField {
      case emailTextfield:
         emailTextfield.endEditing(true)
         return true
      case pwTextfield:
         pwTextfield.endEditing(true)
         return true
      default:
         return false
      }
   }
}
