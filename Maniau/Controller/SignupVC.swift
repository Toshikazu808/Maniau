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
      emailTextfield.delegate = self
      pwTextfield.delegate = self
   }
   
   @IBAction func backTapped(_ sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
   }
   
   @IBAction func signupTapped(_ sender: UIButton) {
      let email = emailTextfield.text ?? ""
      let pw = pwTextfield.text ?? ""
      let err = Utilities.validateFields(email, pw)
      if err == nil {
         createUser(email, pw)
      } else {
         showError(err!)
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
            let saveAutoLogin = Bool(Defaults.autoLogin.bool(forKey: Defaults.autoLoginKey))
            if saveAutoLogin {
               self?.saveUserInfoToDefaults(email, pw)
            }
            self?.clearLoginTextFields(self!.emailTextfield, self!.pwTextfield)
         }
      }
   }
   
   private func saveUserInfoToDefaults(_ email: String, _ pw: String) {
      let encoder = JSONEncoder()
      let user = UserLogin(email, pw)
      if let encoded = try? encoder.encode(user) {
         Defaults.userInfo.setValue(encoded, forKey: Defaults.userInfoKey)
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
