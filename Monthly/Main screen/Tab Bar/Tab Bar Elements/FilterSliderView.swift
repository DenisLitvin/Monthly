//
//  FilterSliderView.swift
//  Monthly
//
//  Created by Denis Litvin on 10/19/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import FlexLayout
import ClipLayout

class FilterSliderView: UIScrollView {
    
    private let contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSelf()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - PRIVATE
    private func setUpSelf() {
        backgroundColor = .red
        contentSize = contentView.flex.sizeThatFits(size: CGSize(width: 9999, height: clip.wantsSize.height))

    }
}
