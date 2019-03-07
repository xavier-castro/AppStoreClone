//
//  AppFullscreenController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/6/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class AppFullScreenController: UITableViewController {

    var dismissHandler: (() ->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get rid of all lines in Table
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.item == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            return headerCell
        }

        let cell = AppFullscreenDescriptionCell()
        return cell

    }

    // TODO: Finish
    @objc func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }
        return super.tableView(tableView, heightForRowAt: indexPath) // Let table view handle height automatically for you
    }

}
