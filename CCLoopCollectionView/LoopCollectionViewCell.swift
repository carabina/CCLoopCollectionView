//
//  LoopCollectionViewCell.swift
//  TestLoopCollectionView
//
//  Created by cuicc on 2018/3/5.
//  Copyright © 2018年 cuicc. All rights reserved.
//

import UIKit

class LoopCollectionViewCell: UICollectionViewCell {
    var contentImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentImageView = UIImageView(frame: CGRect(x: 0, y: frame.origin.y, width: frame.size.width, height: frame.size.height))
        self.addSubview(contentImageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
