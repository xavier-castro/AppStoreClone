//
//  TodayController.swift
//  App-Store-Mockup
//
//  Created by Xavier Castro on 3/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = #colorLiteral(red: 0.9555082917, green: 0.9493837953, blue: 0.9556146264, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
    }

    var appFullScreenController: AppFullScreenController!

    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let appFullscreenController = AppFullScreenController()
        appFullscreenController.dismissHandler = {
            self.handleRemoveRedView()
        }

        let redView = appFullscreenController.view!
        redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        view.addSubview(redView)

        addChild(appFullscreenController) // Need addChild so you can see header in tableViewController

        self.appFullScreenController = appFullscreenController

        // Find out what cell you are in
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        print(cell.frame)

        // Use absolute coordinates to find the acutal x, y for a cell
        // Starting frame knows exactly where the cell is
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }

        self.startingFrame = startingFrame

        // Auto layout constraint animations
        // 4 anchors
        redView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = redView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = redView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = redView.heightAnchor.constraint(equalToConstant: startingFrame.height)

        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        self.view.layoutIfNeeded()

        redView.layer.cornerRadius = 16

        // We're using frames for animation
        // Frames are not reliable enough for animations

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height

            self.view.layoutIfNeeded() // Starts animation

            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)

        }, completion: nil)

    }

    var startingFrame: CGRect?

    @objc func handleRemoveRedView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            // This brings your table view back into the proper position with smooth animation
            self.appFullScreenController.tableView.contentOffset = .zero

            // Frame code is bad, use this instead
            guard let startingFrame = self.startingFrame else { return }

            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height

            self.view.layoutIfNeeded()

            self.tabBarController?.tabBar.transform = .identity
        }, completion: { _ in
            self.appFullScreenController.view.removeFromSuperview()
            self.appFullScreenController.removeFromParent()
        })
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 64, height: 450)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
