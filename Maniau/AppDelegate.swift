//
//  AppDelegate.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   let gcmMessageIDKey = "gcm.message_id"
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//      UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
      requestNotificationAuthorization(application: application)
      FirebaseApp.configure()
      Messaging.messaging().delegate = self
      
      if #available(iOS 10.0, *) {
         // For iOS 10 display notification (sent via APNS)
         UNUserNotificationCenter.current().delegate = self
         
         UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
               print("Error when requesting authorization: \(error)")
               return
            }
            guard granted else {
               print("Notification center request not granted")
               return
            }
            DispatchQueue.main.async {
               application.registerForRemoteNotifications()
            }
         }
      } else {
         let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
         application.registerUserNotificationSettings(settings)
      }
      
      return true
   }
   
   // MARK: UISceneSession Lifecycle
   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      // Called when a new scene session is being created.
      // Use this method to select a configuration to create the new scene with.
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }
   
   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      // Called when the user discards a scene session.
      // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
      // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
   }
   
   // MARK: - Local Notifications
   private func requestNotificationAuthorization(application: UIApplication) {
      UNUserNotificationCenter.current().delegate = self
      let center = UNUserNotificationCenter.current()
      let options: UNAuthorizationOptions = [.alert, .badge, .sound]
      center.requestAuthorization(options: options) { granted, error in
         if let error = error {
            print(error.localizedDescription)
         }
      }
   }
   
   // MARK: - Firebase Push Notifications
   func application(_ application: UIApplication,
                    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                     -> Void) {
      // Do something with message data here.
      if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
      }
      // Print full message.
      print(userInfo)
      completionHandler(UIBackgroundFetchResult.newData)
   }
   
   // In order to receive notifications you must implement these methods
   func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Application didFailToRegisterForRemoteNotificationsWithError: \(error)")
   }
   
   func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("Application didRegisterForRemoteNOtificationsWithDeviceToken: \(deviceToken)")
   }
}

// Cloud messaging
extension AppDelegate: MessagingDelegate {
   func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print(#function)
      Messaging.messaging().token { token, error in
        if let error = error {
          print("Error fetching FCM registration token: \(error)")
        } else if let token = token {
          print("\nFCM registration token: \(token)")
        }
      }
      // Store token in Firestore for sending notifications from server in the future
      
      print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
   }
}

// User Notifications (AKA InApp Notifications)
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
   // Receive displayed notifications for iOS 10 devices.
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void) {
      
      let userInfo = notification.request.content.userInfo
      if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
      }
      print(userInfo)
      completionHandler([[.banner, .badge, .sound]])
   }
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
      
      let content = response.notification.request.content
      print("Title: \(content.title)")
      print("Body: \(content.body)")
      
      if let userInfo = content.userInfo as? [String: Any], let aps = userInfo["aps"] as? [String: Any] {
         print("aps: \(aps)")
      }
      
//      let userInfo = response.notification.request.content.userInfo
//      if let messageID = userInfo[gcmMessageIDKey] {
//         print("Message ID: \(messageID)")
//      }
//      // Do something with message data.
//      print(userInfo)
//      completionHandler()
   }
   
}
