//
//  BaseTodayCell.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/7/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {

    var todayItem: TodayItem!

    override var isHighlighted: Bool {
        didSet {
            var transform: CGAffineTransform = .identity
            if isHighlighted {
                transform = .init(scaleX: 0.9, y: 0.9)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = transform
            })
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Shadow for cell
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shouldRasterize = true // Will make your shadows less laggy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
