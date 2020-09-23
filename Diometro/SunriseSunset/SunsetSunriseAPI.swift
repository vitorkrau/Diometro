//
//  SunsetSunriseAPI.swift
//  Diometro
//
//  Created by Vitor Krau on 22/09/20.
//

import Foundation

var APIurl = "https://api.sunrise-sunset.org/json?"

func fetchTimes() -> Result<SunriseSunset?, NetworkError> {
    let lm = LocationViewModel()
    let url = URL(string: APIurl + "lat=\(lm.location.latitude)&lng=\(lm.location.longitude)")!
    var result: Result<SunriseSunset?, NetworkError>!
    
    let semaphore = DispatchSemaphore(value: 0)
    
   URLSession.shared.dataTask(with: url){ (data, _, _) in
        if let data = data{
            result = .success(try? JSONDecoder().decode(SunriseSunset.self, from: data))
        }else{
            result = .failure(.server)
        }
        semaphore.signal()
    }.resume()
    
    semaphore.wait()
    
    return result
}


enum NetworkError: Error {
    case url
    case server
}
