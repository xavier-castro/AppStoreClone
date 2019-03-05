//
//  AppGroup.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/4/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let name: String
    let artistName: String
    let artworkUrl100: String
}
