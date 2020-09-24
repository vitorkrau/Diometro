//
//  DiometroApp.swift
//  Diometro
//
//  Created by Vitor Krau on 18/09/20.
//

import SwiftUI
import UserNotifications

@main
struct DiometroApp: App {
    @Environment(\.scenePhase) private var phase
    
    var time: Time = Time.instance
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("User Accepted")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
                fetchTimes(completion: {result in
                    switch result{
                    case .success(let times):
                        time.sunsetSunrise = times
                    case .failure(let error):
                        print(error)
                    }
                })
            case .background:
                scheduleNotifications()
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}
