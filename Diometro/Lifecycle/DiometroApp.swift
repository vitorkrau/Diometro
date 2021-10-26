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
    @ObservedObject var appContainer: AppContainer = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            if appContainer.enableFeatures {
                appContainer.createHomeFeaturesView()
            }
            else {
                appContainer.createHomeView()
            }
        }
    }
}
