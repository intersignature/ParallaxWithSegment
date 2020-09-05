//
//  ViewController.swift
//  ParallaxWithSegment
//
//  Created by Drink Sirichai on 4/9/2563 BE.
//  Copyright © 2563 Drink Sirichai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!

    @IBOutlet weak var heightOfHeaderViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topOfFirstCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topOfSecondCollectionViewConstraint: NSLayoutConstraint!

    private let scrollTopEdgeInsets: CGFloat = 169
    private let minScrolling: CGFloat = 31
    private var currentFirstCollectionOffset: CGFloat = 0
    private var currentSecondCollectionOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Collection view setup
        firstCollectionView.register(UINib(nibName: "DataCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cell")
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self

        secondCollectionView.register(UINib(nibName: "DataCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cell")
        secondCollectionView.delegate = self
        secondCollectionView.dataSource = self

        // MARK: - Parallax setup
        firstCollectionView.contentInset = .init(top: scrollTopEdgeInsets, left: 0, bottom: 0, right: 0)
        secondCollectionView.contentInset = .init(top: scrollTopEdgeInsets, left: 0, bottom: 0, right: 0)
        topOfFirstCollectionViewConstraint.constant = minScrolling
        topOfSecondCollectionViewConstraint.constant = minScrolling
    }
    
    @IBAction func onSegmentedValueChanged(_ sender: UISegmentedControl) {

        firstCollectionView.isHidden = sender.selectedSegmentIndex == 1
        secondCollectionView.isHidden = sender.selectedSegmentIndex == 0

        if sender.selectedSegmentIndex == 0 {
            if currentSecondCollectionOffset < 0 {
                firstCollectionView.contentOffset.y = currentSecondCollectionOffset
            } else {
                firstCollectionView.contentOffset.y = max(0, currentFirstCollectionOffset)
            }
        } else {
            if currentFirstCollectionOffset < 0 {
                secondCollectionView.contentOffset.y = currentFirstCollectionOffset
            } else {
                secondCollectionView.contentOffset.y = max(0, currentSecondCollectionOffset)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let maxHeight: CGFloat = view.bounds.size.height // ความสูงที่มากที่สุดที่จะเป็นไปได้
        let yPos = scrollView.contentOffset.y // ตำแหน่งล่าสุดของ collection view
        let headerViewHeight = (maxHeight - yPos) - (maxHeight - minScrolling) // ความสูงปัจจุบันของ header view

        heightOfHeaderViewConstraint.constant = max(headerViewHeight, minScrolling)

        if scrollView == firstCollectionView {
            currentFirstCollectionOffset = scrollView.contentOffset.y
        } else {
            currentSecondCollectionOffset = scrollView.contentOffset.y
        }
    }
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DataCollectionViewCell

        cell.titleLabel.text = "cell at index: \(indexPath.row)"

        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return .init(width: view.bounds.width, height: 80)
    }
}
