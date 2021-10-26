//
//  BoredModel.swift
//  Diometro
//
//  Created by Vitor Krau on 25/10/21.
//

import Foundation

struct BoredModel: Codable {
    let activity: String
    let type: String
    let participants: Int
    let price: Double
    let link: String
    let key: String
    let accessibility: Double
}
