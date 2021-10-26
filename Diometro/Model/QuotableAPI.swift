//
//  QuotableAPI.swift
//  Diometro
//
//  Created by Vitor Krau on 25/10/21.
//

import Foundation

// 


struct QuotableModel: Codable {
    let _id: String
    // The quotation text
    let content: String
    // The full name of the author
    let author: String
    // The `slug` of the quote author
    let authorSlug: String
    // The length of quote (number of characters)
    let length: Int
    // An array of tag names for this quote
    let tags: [String]
}
