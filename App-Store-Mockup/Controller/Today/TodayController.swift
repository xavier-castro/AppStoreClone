//
//  TodayController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    var items = [TodayItem]()

    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()

    // Fix tab bar from snapping out from the bottom
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }

    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.showsVerticalScrollIndicator = false
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0

        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()

        fetchData()

        collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }

    fileprivate func fetchData() {
        let dispatchGroup = DispatchGroup()
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            if let err = err {
                print("Error during fetch data:", err)
                return
            }
            topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        // Completion block
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            if let err = err {
                print("Enter during fetch data:", err)
                return
            }
            gamesGroup = appGroup
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            // I'll have access to top grossing and games
            print("Finish fetching")
            self.activityIndicatorView.stopAnimating()
            self.items = [
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),

                TodayItem.init(category: "Daily List", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),

                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1), cellType: .single, apps: []),

                TodayItem.init(category: "Daily List", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "garden"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),

            ]
            self.collectionView.reloadData()
        }
    }

    var appFullscreenController: AppFullscreenController!

    // If cell type is in multiple group, will open and turn to fullscreen
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        default:
            showSingleAppFullscreen(indexPath: indexPath)
        }
    }

    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = {
            self.handleAppFullscreenDismiss()
        }
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController

        // #1 Setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)

        // #2 Add a blur effect view

        // #3 Not to interfere with our UITableView scrolling
    }

    // Still allow scroll down even with new gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    var appFullscreenBeginOffset: CGFloat = 0

    @objc func handleDrag(gesture: UIPanGestureRecognizer) {

        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }

        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }

        let translationY = gesture.translation(in: appFullscreenController.view).y

        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset // Smooth motion
                var scale = 1 - trueOffset / 1000 // Shrinking ratio
                scale = min(1, scale) // Make sure you have a min/max limit for scaling
                scale = max(0.5, scale)
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }
        } else if gesture.state == .ended {
            if translationY > 0 {
                if translationY > 0 {
                    handleAppFullscreenDismiss()
                }
            }
        }
    }

    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        self.collectionView.isUserInteractionEnabled = false
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }

    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        addChild(appFullscreenController)
        setupStartingCellFrame(indexPath)
        guard let startingFrame = self.startingFrame else { return }

        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: CGSize(width: startingFrame.width, height: startingFrame.height))

        self.view.layoutIfNeeded()
    }

    var anchoredConstraints: AnchoredConstraints?

    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.blurVisualEffectView.alpha = 1

            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height

            self.view.layoutIfNeeded() // starts animation
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)

            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()

        }, completion: nil)
    }

    fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
        // Setup appFullScreenController
        setupSingleAppFullscreenController(indexPath)
        // Setup fullscreen in its starting position
        setupAppFullscreenStartingPosition(indexPath)
        // Begin the fullscreen animation
        beginAnimationAppFullscreen()
    }

    var startingFrame: CGRect?
    @objc func handleAppFullscreenDismiss() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.blurVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity

            self.appFullscreenController.tableView.contentOffset = .zero

            guard let startingFrame = self.startingFrame else { return }
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height

            self.view.layoutIfNeeded()
            self.tabBarController?.tabBar.transform = .identity

            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            self.appFullscreenController.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
        }, completion: { _ in
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.isUserInteractionEnabled = false
        return cell

    }

    // Figure out which cell we are clicking into
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        let collectionView = gesture.view
        var superview = collectionView?.superview
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                let apps = self.items[indexPath.item].apps
                fullController.apps = apps
                present(BackEnabledNavigationController(rootViewController: fullController), animated: true)
                return
            }
            superview = superview?.superview
        }
    }

    static let cellSize: CGFloat = 500

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }

}
