//
//  NotificationManager.swift
//  Diometro
//
//  Created by Vitor Krau on 26/10/21.
//

import Foundation
import UserNotifications


class NotificationCenter {
    let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { _, _ in })
    }
    
    func scheduleNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Dia? Noite?"
        content.body = "Você já viu se é dia ou noite hoje?"
        content.sound = UNNotificationSound.default
        for index in 1...60 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(index) * Double.random(in: 70000...86400), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }

}
