//
//  AppFullscreenHeaderCell.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/6/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {

    let todayCell = TodayCell()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(todayCell)
        todayCell.fillSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
