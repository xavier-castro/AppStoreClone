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
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        print("Fetching iTunes apps from Service layer")
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }

    func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/25/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }

    func fetchGames(completion: @escaping (AppGroup?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/25/explicit.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }

    // Helper function
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }

    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }

    // Declare my generic json function here
    // Generic is to declare the type later on
    func fetchGenericJSONData<Type: Decodable>(urlString: String, completion: @escaping (Type?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, resp, err) in

            if let err = err {
                completion(nil, err)
                return
            }

            do {
                // Success
                let objects = try JSONDecoder().decode(Type.self, from: data!)
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
}
