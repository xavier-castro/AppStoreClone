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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let redView = UIView()
        redView.backgroundColor = .red
        redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        view.addSubview(redView)

        // Find out what cell you are in
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        print(cell.frame)

        // Use absolute coordinates to find the acutal x, y for a cell
        // Starting frame knows exactly where the cell is
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }

        self.startingFrame = startingFrame
        redView.frame = startingFrame
        redView.layer.cornerRadius = 16

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            redView.frame = self.view.frame
        }, completion: nil)

    }

    var startingFrame: CGRect?

    @objc func handleRemoveRedView(gesture: UITapGestureRecognizer) {
        // Access starting frame
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            gesture.view?.frame = self.startingFrame ?? .zero
        }, completion: { _ in
            gesture.view?.removeFromSuperview()
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
