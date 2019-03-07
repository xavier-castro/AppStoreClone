//
//  TodayCell.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {

    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))

    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 28))

    let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))

    let descriptionLabel = UILabel(text: "All the tools and the apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        layer.cornerRadius = 16

        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill

        // Need image container to fix sizing of images in stack view
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: CGSize(width: 240, height: 240))

        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            imageContainerView,
            descriptionLabel
            ], spacing: 8)
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
