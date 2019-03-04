//
//  AppsSearchController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/2/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import SDWebImage

class AppsSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        fetchITunesApps()
    }

    fileprivate var appResults = [Result]()

    fileprivate func fetchITunesApps() {
        Service.shared.fetchApps { (results, error) in
            if let error = error {
                print("Failed to fetch apps:", error)
                return
            }
            self.appResults = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        // We are getting our search result back using a completion block
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        let appResult = appResults[indexPath.item]
        cell.appIconLabel.text = appResult.trackName
        cell.categoryLabel.text = appResult.primaryGenreName
        cell.ratingsLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"

        let url = URL(string: appResult.artworkUrl100)
        cell.appIconImageView.sd_setImage(with: url)
        cell.screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
        cell.screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
        cell.screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appResults.count
    }

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
