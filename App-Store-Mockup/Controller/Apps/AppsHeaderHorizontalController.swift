//
//  AppsHeaderHorizontalController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/4/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class AppsHeaderHorizontalController: BaseListController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .yellow
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: cellId)

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
