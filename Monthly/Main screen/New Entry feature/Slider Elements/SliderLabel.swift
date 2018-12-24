//
//  SliderLabel.swift
//  Monthly
//
//  Created by Denis Litvin on 08.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

class SliderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.Elements.labelText
        font = UIFont.dynamic(17, family: .avenir).bolded
        numberOfLines = 2
        clip.enable()
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

