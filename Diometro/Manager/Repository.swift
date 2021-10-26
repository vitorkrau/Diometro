//
//  Repository.swift
//  Diometro
//
//  Created by Vitor Krau on 25/10/21.
//

import Foundation
import SwiftUI

class Repository {
    
    let defaults: UserDefaults = UserDefaults.standard
    @ObservedObject var appContainer: AppContainer
    
    init(appContainer: AppContainer){
        self.appContainer = appContainer
    }
    
    func saveValue() {
        defaults.set(appContainer.enableFeatures, forKey: "features")
    }
    
    func loadValue() {
        if let feature = defaults.value(forKey: "features") as? Bool {
            appContainer.enableFeatures = feature
        }
        
        APIRequest.shared.fetchAPI(endpoint: "https://diometro-api-backup.herokuapp.com", model: DiometroAPI.self, completion: {
            result in
            switch result {
                case .success(let model):
                    self.appContainer.enableFeatures = model.feature
                    self.saveValue()
                case .failure(_):
                    return
                }
        })
    }
}
