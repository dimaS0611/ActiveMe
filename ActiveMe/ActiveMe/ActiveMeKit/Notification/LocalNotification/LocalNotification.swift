//
//  LocalNotification.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 15.05.22.
//

import Foundation
import UserNotifications

class LocalNotification {

  static let shared = LocalNotification()
  let notificationCenter = UNUserNotificationCenter.current()

  private init() {
    notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in

      if granted {
        self.notificationCenter.getNotificationSettings { (settings) in
          guard settings.authorizationStatus == .authorized else { return }
        }
      } else if let error = error {
        print(error.localizedDescription)
      }
    }
  }

  func dataHasRecorded() {
    let content = UNMutableNotificationContent()
    content.title = "Sleep data has been successfully recorded!🫡"
    content.sound = UNNotificationSound.default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    notificationCenter.add(request) { (error) in
      print(error?.localizedDescription ?? "")
    }
  }
}
