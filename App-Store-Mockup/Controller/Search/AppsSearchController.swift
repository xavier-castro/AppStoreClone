//
//  AppsSearchController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/2/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import SDWebImage

class AppsSearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    fileprivate let cellId = "cellId"

    fileprivate let searchController = UISearchController(searchResultsController: nil)

    fileprivate let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textColor = UIColor(white: 0.7, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 50, left: 50, bottom: 0, right: 50))
        setupSearchBar()
        // fetchITunesApps()
    }

    // Typical way to set up search bar in new iOS
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self // Notified when text is being put
    }

    var timer: Timer?
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)

        // Introduce some delay before performing a search
        // This is called "throttling the search"
        timer?.invalidate() // Makes it fire the search term just once after 0.5
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            // This will actually fire my search
            Service.shared.fetchApps(searchTerm: searchText) { (res, err) in
                if let err = err {
                    print("Failed to fetch apps:", err)
                    return
                }
                self.appResults = res?.results ?? []
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }

    fileprivate var appResults = [Result]()

    fileprivate func fetchITunesApps() {
        Service.shared.fetchApps(searchTerm: "") { (res, error) in
            if let error = error {
                print("Failed to fetch apps:", error)
                return
            }
            self.appResults = res?.results ?? []
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
        cell.appResult = appResults[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = appResults.count != 0
        return appResults.count
    }

}
