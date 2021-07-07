//
//  ViewController.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginVC: UIViewController {
   @IBOutlet weak var loginView: UIView!
   @IBOutlet weak var emailTextfield: UITextField!
   @IBOutlet weak var pwTextfield: UITextField!
   @IBOutlet weak var loginBtn: UIButton!
//   var saveAutoLogin = false
   let emailPlaceholder = "email"
   let pwPlaceholder = "password"   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      loginView.layer.cornerRadius = 6
      loginBtn.layer.cornerRadius = 15
      emailTextfield.delegate = self
      pwTextfield.delegate = self
      checkForLoggedInUser()
   }
   
   private func checkForLoggedInUser() {
      if Auth.auth().currentUser != nil {
         print("User is already signed in")
         let email = loadUserEmail()
         transitionToHome(email)
      } else {
         print("No current user. Tap login button to login like normal.")
      }
   }
   
   private func loadUserEmail() -> String {
      var info: String = ""
      if let savedInfo = Defaults.userInfo.object(forKey: Defaults.userInfoKey) as? Data {
         let decoder = JSONDecoder()
         if let loadedInfo = try? decoder.decode(UserLogin.self, from: savedInfo) {
            info = loadedInfo.email
         }
      }
      return info
   }

   @IBAction func loginTapped(_ sender: UIButton) {
      let email = emailTextfield.text ?? ""
      let pw = pwTextfield.text ?? ""
      let err = validateFields(email, pw)
      if err == nil {
         loginUser(email, pw)
         clearLoginTextFields(emailTextfield, pwTextfield)
      } else {
         showError(err!)
      }
   }
   
   private func loginUser(_ email: String, _ pw: String) {
      Auth.auth().signIn(withEmail: email, password: pw) { [weak self] _, error in
         if let error = error {
            self?.showError(error.localizedDescription)
         } else {
            self?.transitionToHome(email)
         }
      }
   }
   
   @IBAction func signupTapped(_ sender: UIButton) {
      clearLoginTextFields(emailTextfield, pwTextfield)
      // Go to SignupVC via Storyboard segue
   }
}

extension LoginVC: UITextFieldDelegate {
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
