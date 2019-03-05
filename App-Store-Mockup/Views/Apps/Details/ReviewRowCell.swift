//
//  ReviewRowCell.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {

    let reviewsController = ReviewsController()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(reviewsController.view)
        reviewsController.view.fillSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
