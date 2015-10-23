//
//  CardCell.swift
//  Cards
//
//  Created by Camilo Vera Bezmalinovic on 10/22/15.
//  Copyright © 2015 Camilo Vera Bezmalinovic. All rights reserved.
//

import Foundation
import UIKit

class CardCell : UICollectionViewCell {
    
    class var identifier: String { return "card.cell.id" }
    
    weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //MARK: Create stuff
    private func setup() {
        createImageView()
        contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    private func createImageView() {
        let imageView = UIImageView(frame: bounds)
        imageView.clipsToBounds = true
        imageView.contentMode   = .ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        contentView.addSubview(imageView)
        self.imageView = imageView
    }
}