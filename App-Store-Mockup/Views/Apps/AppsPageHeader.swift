//
//  AppsPageHeader.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/4/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {

    let appHeaderHorizontalController = AppsHeaderHorizontalController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(appHeaderHorizontalController.view)
        appHeaderHorizontalController.view.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
