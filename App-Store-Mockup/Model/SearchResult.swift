//
//  SearchResult.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/3/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
}
