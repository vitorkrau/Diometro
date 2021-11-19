//
//  TimeOfTheDay.swift
//  Diometro
//
//  Created by Vitor Krau on 18/09/20.
//

import UserNotifications
import SwiftUI

class TimeManager: ObservableObject {
    
    @Published var sunsetSunrise: Results? = Results(sunrise: "06:00", sunset: "18:00", solarNoon: "", dayLength: "")
    
    init(_ time: Results? = nil) {
        sunsetSunrise = time
    }
   
    //Get actual hour and minute
    private func getTime() -> [Int]{
        return [Calendar.current.component(.hour, from: Date()), Calendar.current.component(.minute, from: Date())]
    }

    //Return if it's day or night
    func getTimeOfTheDay() -> String{
        if IsItNight() { return "NOITE" } else { return "DIA" }
    }
    
    //Verify if it's night in the current timezone
    func IsItNight() -> Bool{
        let sunriseHour: [Int] = [(Int((sunsetSunrise?.sunrise.components(separatedBy: ":")[0])!)!) + getCurrentTimeZone(), (Int((sunsetSunrise?.sunrise.components(separatedBy: ":")[1])!)!)]
        let sunsetHour = [(Int((sunsetSunrise?.sunset.components(separatedBy: ":")[0])!)!) + getCurrentTimeZone() + 12, (Int((sunsetSunrise?.sunset.components(separatedBy: ":")[1])!)!)]
        let currentTime = getTime()
        
        if currentTime[0] >= sunsetHour[0] || currentTime[0] <= sunriseHour[0]{
            if currentTime[0] == sunsetHour[0]{
                if currentTime[1] > sunsetHour[1]{
                    return true
                }
                return false
            }
            if currentTime[0] == sunriseHour[0]{
                if currentTime[1] < sunriseHour[1]{
                    return true
                }
                return false
            }
            return true
        }
        return false
    }

    //Get currentTimeZone
    func getCurrentTimeZone() -> Int {
        let localTimeZoneAbbreviation: Int = TimeZone.current.secondsFromGMT()
        let gmtAbbreviation = (localTimeZoneAbbreviation / 3600)
        return gmtAbbreviation

    }
}
