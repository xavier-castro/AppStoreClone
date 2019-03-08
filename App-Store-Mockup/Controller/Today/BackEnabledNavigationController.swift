//
//  BackEnabledNavigationController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/7/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    // interactivePopGestureRecognizer is needed so you can swipe back while having the navigation hidden
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }

    // If navigationController stack is more than 2 the back swipe will be enabled
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }

}
