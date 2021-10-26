//
//  FactModel.swift
//  Diometro
//
//  Created by Vitor Krau on 25/10/21.
//

import Foundation


// https://uselessfacts.jsph.pl/random.json?language=en

struct FactModel: Codable {
    let id: String
    let text: String
    let source: String
    let source_url: String
    let language: String
    let permalink: String
}
