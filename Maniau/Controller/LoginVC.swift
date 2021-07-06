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
   var saveAutoLogin = false
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
   
   private func getUserEmailFromFirebase() {
      let id = Auth.auth().currentUser?.uid
      let users = Firestore.firestore().collection(id!)
      let doc = users.document(id!)
      print(id!)
      doc.getDocument { [weak self] document, error in
         if let document = document, document.exists {
            let data = document.data().map(String.init(describing:)) ?? "nil"
            print("data: \(data)")
            print("document: \(document)")
            User.email = Utilities.extractEmail(from: data)
            self?.transitionToHome()
         } else {
            print("Document doesn't exist.")
            self?.transitionToHome()
         }
      }
   }
   
   private func checkForLoggedInUser() {
      if Auth.auth().currentUser != nil {
         print("User is already signed in")
         getUserEmailFromFirebase()
      } else {
         print("No current user")
         DispatchQueue.main.async { [weak self] in
            if let _ = UserDefaults.standard.data(forKey: Defaults.autoLoginKey) {
               self?.checkSavedLoginInfo()
            } else {
               self?.askToSavePw()
            } // let user login like normal
         }
      }
   }
   
   private func checkSavedLoginInfo() {
      saveAutoLogin = Bool(Defaults.autoLogin.bool(forKey: Defaults.autoLoginKey))
      print("saveAutoLogin: \(saveAutoLogin)")
      if saveAutoLogin {
         if let (email, pw) = loadUserInfo() {
            loginUser(email, pw)
            transitionToHome()
         } // else let user login like normal
      } // else let user login like normal
   }
   
   private func loadUserInfo() -> (String, String)? {
      var info: (String, String)? = nil
      if let savedInfo = Defaults.userInfo.object(forKey: Defaults.userInfoKey) as? Data {
         let decoder = JSONDecoder()
         if let loadedInfo = try? decoder.decode(UserLogin.self, from: savedInfo) {
            info = (loadedInfo.email, loadedInfo.pw)
         }
      }
      return info
   }
   
   private func loginUser(_ email: String, _ pw: String) {
      if let _ = UserDefaults.standard.data(forKey: Defaults.autoLoginKey) {
         saveAutoLogin = Bool(Defaults.autoLogin.bool(forKey: Defaults.autoLoginKey))
         if !saveAutoLogin {
            self.askToSavePw()
         }
      }
      Auth.auth().signIn(withEmail: email, password: pw) { [weak self] _, error in
         if let error = error {
            self?.showError(error.localizedDescription)
         } else {
            self?.transitionToHome()
         }
      }
   }

   @IBAction func loginTapped(_ sender: UIButton) {
      let email = emailTextfield.text ?? ""
      let pw = pwTextfield.text ?? ""
      let err = Utilities.validateFields(email, pw)
      if err == nil {
         loginUser(email, pw)
         saveAutoLogin = Bool(Defaults.autoLogin.bool(forKey: Defaults.autoLoginKey))
         if saveAutoLogin {
            saveUserInfoToDefaults(email, pw)
         }
         clearLoginTextFields(emailTextfield, pwTextfield)
      } else {
         showError(err!)
      }
   }
   
   @IBAction func signupTapped(_ sender: UIButton) {
      clearLoginTextFields(emailTextfield, pwTextfield)
      // Go to SignupVC via Storyboard segue
   }
   
   private func saveUserInfoToDefaults(_ email: String, _ pw: String) {
      let encoder = JSONEncoder()
      let user = UserLogin(email, pw)
      if let encoded = try? encoder.encode(user) {
         Defaults.userInfo.setValue(encoded, forKey: Defaults.userInfoKey)
      }
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
