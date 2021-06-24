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
   let emailPlaceholder = "email"
   let pwPlaceholder = "password"
   
   override func viewDidLoad() {
      super.viewDidLoad()
      loginView.layer.cornerRadius = 6
      loginBtn.layer.cornerRadius = 15
      emailTextfield.becomeFirstResponder()
      emailTextfield.delegate = self
      pwTextfield.delegate = self
      checkUserLoggedIn()
      checkSavedLogin()
   }

   @IBAction func loginTapped(_ sender: UIButton) {
      if Auth.auth().currentUser != nil {
         print("User is already signed in")
      } else {
         print("No users signed in")
         let email = emailTextfield.text ?? ""
         let pw = pwTextfield.text ?? ""
         let err = Utilities.validateFields(email, pw)
         if err == nil {
            loginUser(email, pw)
         } else {
            showError(err!)
         }
      }
   }
   
   @IBAction func signupTapped(_ sender: UIButton) {
      clearTextFields(emailTextfield, pwTextfield)
   }
   
   private func checkSavedLogin() {
      let loginSaved = Bool(Defaults.saveLoginTracker.bool(forKey: Defaults.saveLoginKey))
      if loginSaved == false {
         askToSavePw()
      } else {
         let (email, pw) = loadUserInfo()
         loginUser(email, pw)
      }
   }
   
   private func askToSavePw() {
      let alert = UIAlertController(
         title: "Do you want to save your login information?",
         message: "Enabling automatic login will save your username and password to your device.",
         preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
         Defaults.saveLoginTracker.removeObject(forKey: Defaults.saveLoginKey)
         Defaults.saveLoginTracker.setValue(true, forKey: Defaults.saveLoginKey)
      }))
      present(alert, animated: true)
   }
   
   private func checkUserLoggedIn() {
      if Auth.auth().currentUser != nil {
         print("User is already signed in")
         getUserEmailFromFirebase()
      } else {
         print("No current user")
      }
   }
   
   private func loginUser(_ email: String, _ pw: String) {
      Auth.auth().signIn(withEmail: email, password: pw) { [weak self] authResult, error in
         if let error = error {
            self?.showError(error.localizedDescription)
         } else {
            print("authResult: \(String(describing: authResult))")
            self?.saveUserInfoToDefaults(email, pw)
            self?.getUserEmailFromFirebase()
         }
      }
   }
   
   private func loadUserInfo() -> (String, String) {
      var e = ""
      var p = ""
      if let savedInfo = Defaults.saveUserInfoTracker.object(forKey: Defaults.saveUserInfoKey) as? Data {
         let decoder = JSONDecoder()
         if let loadedInfo = try? decoder.decode(UserLogin.self, from: savedInfo) {
            print(loadedInfo.email)
            print(loadedInfo.pw)
            e = loadedInfo.email
            p = loadedInfo.pw
         }
      }
      return (e, p)
   }
   
   private func getUserEmailFromFirebase() {
      let id = Auth.auth().currentUser?.uid
      let users = Firestore.firestore().collection(K.fbUsers)
      let doc = users.document(id!)
      doc.getDocument { [weak self] document, error in
         if let document = document, document.exists {
            let data = document.data().map(String.init(describing:)) ?? "nil"
            print("data: \(data)")
            User.email = Utilities.extractEmail(from: data)
            print("extracted email: \(User.email)")
            self?.transitionToHome()
         }
      }
   }
   
   private func saveUserInfoToDefaults(_ email: String, _ pw: String) {
      let encoder = JSONEncoder()
      let user = UserLogin(email: email, pw: pw)
      if let encoded = try? encoder.encode(user) {
         Defaults.saveUserInfoTracker.setValue(encoded, forKey: Defaults.saveUserInfoKey)
      }
   }
   
   private func transitionToHome() {
      let homeVC = storyboard?.instantiateViewController(identifier: K.homeVC)
      self.navigationController?.pushViewController(homeVC!, animated: true)
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
   
   func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      switch textField {
      case emailTextfield:
         if emailTextfield.text != "" {
            return true
         } else {
            emailTextfield.placeholder = emailPlaceholder
            return false
         }
      case pwTextfield:
         if pwTextfield.text != "" {
            return true
         } else {
            pwTextfield.placeholder = pwPlaceholder
            return false
         }
      default:
         return false
      }
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      switch textField {
      case emailTextfield:
         emailTextfield.text = ""
         emailTextfield.placeholder = emailPlaceholder
      case pwTextfield:
         pwTextfield.text = ""
         pwTextfield.placeholder = pwPlaceholder
      default:
         break
      }
   }
}
