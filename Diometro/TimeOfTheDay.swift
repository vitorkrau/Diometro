//
//  TimeOfTheDay.swift
//  Diometro
//
//  Created by Vitor Krau on 18/09/20.
//

import UserNotifications
import SwiftUI

class Time{
    static var instance = Time()
    var sunsetSunrise : Results?
    
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
        print(getTime())
        print(sunriseHour)
        print(sunsetHour)
        if (getTime()[0] >= sunsetHour[0] && getTime()[1] >= sunsetHour[1]) || (getTime()[0] < sunriseHour[0] && getTime()[1] < sunriseHour[1]) { return true }
        return false
    }

    //Get currentTimeZone
    func getCurrentTimeZone() -> Int {
            let localTimeZoneAbbreviation: Int = TimeZone.current.secondsFromGMT()
            let gmtAbbreviation = (localTimeZoneAbbreviation / 3600)
            return gmtAbbreviation
    }
}


///Global Function -- Set Notification Reminder
func scheduleNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    let content = UNMutableNotificationContent()
    content.title = "Dia? Noite?"
    content.body = "Você já viu se é dia ou noite hoje?"
    content.sound = UNNotificationSound.default
    var dateComponents = DateComponents()
    dateComponents.hour = 04
    dateComponents.minute = 00
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}
