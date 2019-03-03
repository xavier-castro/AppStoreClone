//
//  BaseTabBarController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/2/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Red
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .red
        redViewController.navigationItem.title = "Apps"

        let redNavController = UINavigationController(rootViewController: redViewController)
        redNavController.tabBarItem.title = "Red"
        redNavController.tabBarItem.image = #imageLiteral(resourceName: "apps")
        redNavController.navigationBar.prefersLargeTitles = true

        // MARK: Blue
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .blue
        blueViewController.navigationItem.title = "Search"

        let blueNavController = UINavigationController(rootViewController: blueViewController)
        blueNavController.tabBarItem.title = "Blue"
        blueNavController.tabBarItem.image = #imageLiteral(resourceName: "search")
        blueNavController.navigationBar.prefersLargeTitles = true

        viewControllers = [
            redNavController,
            blueNavController,
        ]
    }
}
