//
//  AppFullscreenController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/6/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class AppFullscreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dismissHandler: (() ->())?
    var todayItem: TodayItem?

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }

    let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        setupCloseButton()
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }

    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        return button
    }()

    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0), size: CGSize(width: 80, height: 40))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.item == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        }

        let cell = AppFullscreenDescriptionCell()
        return cell
    }

    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        return UITableView.automaticDimension
    }

}
