//
//  ReviewCell.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {

    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 16))

    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))

    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))

    let bodyLabel = UILabel(text: "Review body\nReview body\nReview body\n", font: .systemFont(ofSize: 16), numberOfLines: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = #colorLiteral(red: 0.9521474242, green: 0.9424777627, blue: 0.9794601798, alpha: 1)

        layer.cornerRadius = 16
        clipsToBounds = true

        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel, UIView(), authorLabel
                ], customSpacing: 8),
            starsLabel,
            bodyLabel
            ], spacing: 12)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(.init(0)), for: .horizontal) // Gives name title priority so it doesn't get truncuated
        authorLabel.textAlignment = .right
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
