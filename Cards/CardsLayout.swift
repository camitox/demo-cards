//
//  CardsLayout.swift
//  Cards
//
//  Created by Camilo Vera Bezmalinovic on 9/30/15.
//  Copyright © 2015 Camilo Vera Bezmalinovic. All rights reserved.
//

import Foundation
import UIKit

class CardsLayout : UICollectionViewFlowLayout
{
    
    var slowness = CGFloat(200)
    var cardsAngle = CGFloat(M_PI_4/4)
    var selectedIndexPath:NSIndexPath? {
        didSet {
            invalidateLayout()
        }
    }
    
    var anchorPoint = CGPoint(x: 0.5, y: 1.2)
    
    private var cardsAttributes : [NSIndexPath:UICollectionViewLayoutAttributes] = [:]

    private var itemsCount : Int {
        return collectionView!.numberOfItemsInSection(0)
    }
    
    override func prepareLayout() {
        itemSize = CGSize(width: 250, height: 350)
        
        for i in 0..<itemsCount
        {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            cardsAttributes[indexPath] = cardLayout(indexPath)
        }
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cardsAttributes[indexPath]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cardsAttributes.filter{ CGRectIntersectsRect($0.1.frame, rect) }.map{ $0.1 }
    }
    
    
    func cardLayout(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let index      = indexPath.item
        let bounds     = collectionView!.bounds
        let center     = CGPoint(x: CGRectGetMidX(bounds), y: bounds.height/2)

        attributes.size = itemSize
        attributes.zIndex = index

        if let selected = selectedIndexPath {
            if index == selected.item {
                attributes.center = center
                attributes.zIndex = itemsCount
            }
            else {
                let spacing = bounds.width/CGFloat(itemsCount)
                let x       = center.x - bounds.width/2 + itemSize.width/2 + spacing * CGFloat(index)
                
                attributes.center = CGPoint(x: x, y: bounds.height + itemSize.width/6)
            }
            
        }
        else {
            let anchor          = CGPoint(x: center.x * 2 * anchorPoint.x , y: bounds.height * anchorPoint.y)
            let offset          = collectionView!.contentSize.width/2 - (collectionView!.contentOffset.x + bounds.width/2) //let's set the cursor in the middle
            let maxSideOffset   = (collectionView!.contentSize.width - bounds.width)/2
            let additionalAngle = (offset / maxSideOffset * CGFloat(M_PI)) /  (34.0 / CGFloat(itemsCount))
            let relativeIndex   = CGFloat(index) - CGFloat(itemsCount)/2.0 + 0.5
            let relativeAnggle  = CGFloat(relativeIndex) * cardsAngle + additionalAngle

            attributes.center = rotatePoint(center, angle: relativeAnggle, anchorPoint: anchor)
            attributes.transform = CGAffineTransformMakeRotation(relativeAnggle)
        }
        return attributes
    }
    
    
    func rotatePoint(point:CGPoint, angle: CGFloat, anchorPoint: CGPoint) -> CGPoint {
        var newPoint = point
        newPoint.x -= anchorPoint.x
        newPoint.y -= anchorPoint.y
        newPoint = __CGPointApplyAffineTransform(newPoint, CGAffineTransformMakeRotation(angle))
        newPoint.x += anchorPoint.x
        newPoint.y += anchorPoint.y
        return newPoint
    }
    
    
    //we are going to use this array to filter what rows should be animated on insert
    var insertIndexPaths : [NSIndexPath]?
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        insertIndexPaths = updateItems.filter { $0.updateAction == .Insert }.map{ $0.indexPathAfterUpdate }
    }
    
    override func finalizeCollectionViewUpdates() {
        insertIndexPaths = nil
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if let insertIndexPaths = insertIndexPaths where insertIndexPaths.contains(itemIndexPath) {
            let bounds = collectionView!.bounds
            attributes?.size   = itemSize
            attributes?.center = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMaxY(bounds) + itemSize.height/2)
            attributes?.zIndex = itemsCount
        }
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake( CGFloat(itemsCount) * slowness, collectionView!.bounds.height)
    }
}