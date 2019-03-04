//
//  Service.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/3/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import Foundation

class Service {
    static let shared = Service()
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        print("Fetching iTunes apps from Service layer")
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        guard let url = URL(string: urlString) else { return }
        // Fetch data from internet
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error  = error {
                print("Failed to fetch apps:", error)
                completion([], nil)
                return
            }
            // Successful
            guard let data = data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch let jsonError {
                print("Failed to decode json:", jsonError)
                completion([], jsonError)
            }
            }.resume() // Fires off the request
    }
}
