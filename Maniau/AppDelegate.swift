//
//  AppDelegate.swift
//  Maniau
//
//  Created by Ryan Kanno on 6/22/21.
//

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   let gcmMessageIDKey = "gcm.message_id"
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()
      Messaging.messaging().delegate = self
      
      if #available(iOS 10.0, *) {
         // For iOS 10 display notification (sent via APNS)
         UNUserNotificationCenter.current().delegate = self
         
         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
         UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
         )
      } else {
         let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
         application.registerUserNotificationSettings(settings)
      }
      application.registerForRemoteNotifications()
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
   //: UISceneSession Lifecycle
   
   // MARK: Firebase Push Notifications
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
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      // Store token in Firestore for sending notifications from server in the future
      print(dataDict)
   }
}

// User Notifications (AKA InApp Notifications)
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
   // Receive displayed notifications for iOS 10 devices.
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping( UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo
      if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
      }
      print(userInfo)
      completionHandler([[.banner, .badge, .sound]])
      
   }
   
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
      }
      // Do something with message data.
      print(userInfo)
      completionHandler()
   }
   
}
