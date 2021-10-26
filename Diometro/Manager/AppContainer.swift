//
//  AppContainer.swift
//  Diometro
//
//  Created by Vitor Krau on 25/10/21.
//

import Foundation
import UserNotifications


class AppContainer: ObservableObject {
    
    let lm: LocationManager = LocationManager()
    let timeManager: TimeManager = TimeManager()
    let notificationCenter: NotificationCenter = NotificationCenter()
    lazy var repository: Repository = Repository(appContainer: self)
    @Published var enableFeatures: Bool = true
    
    init() {
        notificationCenter.requestAutorization()
        APIRequest.shared.fetchAPI(endpoint: "https://api.sunrise-sunset.org/json?" + "lat=\(self.lm.location.latitude)&lng=\(self.lm.location.longitude)" , model: SunriseSunset.self, completion: { result in
            switch result {
                case .success(let times):
                self.timeManager.sunsetSunrise = times.results
                case .failure(let error):
                    print(error)
                }
        })
        self.repository.loadValue()
        notificationCenter.scheduleNotifications()
    }
}

//MARK: HomeFactory
protocol HomeFactory {
    func createHomeView() -> HomeView
}

extension AppContainer: HomeFactory {
    func createHomeView() -> HomeView {
        return HomeView(timeManager: timeManager)
    }
}


//MARK: HomeFeaturesFactory
protocol HomeFeaturesFactory {
    func createHomeFeaturesView() -> HomeFeaturesView
}

extension AppContainer: HomeFeaturesFactory {
    func createHomeFeaturesView() -> HomeFeaturesView {
        return HomeFeaturesView(timeManager: timeManager)
    }
}
