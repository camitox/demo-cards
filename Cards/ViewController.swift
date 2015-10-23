//
//  ViewController.swift
//  Cards
//
//  Created by Camilo Vera Bezmalinovic on 9/30/15.
//  Copyright © 2015 Camilo Vera Bezmalinovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

    var layout = CardsLayout()
    var collectionView: UICollectionView!
    var cards : [String] = []
    private var allCards : [String] = []
    
    //MARK: Creating stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
        createTapGesture()
        
        allCards = (0...37).map{ "\($0).png" }
        for _ in 0..<7 {
            cards.append(randomCard())
        }

    }
    
    func createCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerClass(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    func createTapGesture() {
        let tap = UITapGestureRecognizer(target: nil, action: "")
        tap.delegate = self
        self.collectionView.addGestureRecognizer(tap)
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CardCell.identifier, forIndexPath: indexPath) as! CardCell
        cell.imageView.image = UIImage(named: cards[indexPath.row])
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selected : NSIndexPath? = layout.selectedIndexPath == indexPath ? nil : indexPath

        collectionView.performBatchUpdates({ () -> Void in
            self.layout.selectedIndexPath = selected
            }) { (_) -> Void in
        }
    }
    
    //MARK: UIGestureRecognizerDelegate
    //only checks where would be touch, and then discard the touch..
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view == collectionView {
            let point = touch.locationInView(collectionView)
            if collectionView.indexPathForItemAtPoint(point) == nil {
               draw()
            }
        }
        
        return false
    }
    
    func draw() {
        let count = cards.count
        cards.append(randomCard())
        collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: count, inSection: 0)])
    }
    
    func randomCard() -> String {
        return allCards[Int(arc4random_uniform(UInt32(allCards.count)))]
    }

}

