//
//  SunsetSunriseAPI.swift
//  Diometro
//
//  Created by Vitor Krau on 22/09/20.
//

import Foundation

var APIurl = "https://api.sunrise-sunset.org/json?"

func fetchTimes(completion: @escaping (Result<Results?, NetworkError>) -> Void){
    let lm = LocationViewModel()
    let url = URL(string: APIurl + "lat=\(lm.location.latitude)&lng=\(lm.location.longitude)")!
    
    URLSession.shared.dataTask(with: url){ (data, _, _) in
        if let data = data{
            let values = try? JSONDecoder().decode(SunriseSunset.self, from: data)
            completion(.success(values?.results))
        }else{
            completion(.failure(.server))
        }
    }.resume()

}


enum NetworkError: Error {
    case url
    case server
}
