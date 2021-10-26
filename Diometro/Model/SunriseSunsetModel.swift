//
//  SunriseSunsetModel.swift
//  Diometro
//
//  Created by Vitor Krau on 22/09/20.
//

import Foundation

// MARK: - SunriseSunset
struct SunriseSunset: Codable {
    let results: Results
    let status: String
}

// MARK: - Results
struct Results: Codable {
    let sunrise, sunset, solarNoon, dayLength: String

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
        case solarNoon = "solar_noon"
        case dayLength = "day_length"
    }
}
