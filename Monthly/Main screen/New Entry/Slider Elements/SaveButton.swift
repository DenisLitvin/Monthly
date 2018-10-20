//
//  SaveButton.swift
//  Monthly
//
//  Created by Denis Litvin on 13.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit


class SaveButton: TabBarButton {
    
    var titleView: UIView!
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = true
        let diameter: CGFloat = 47
        isHidden = true
        frame = CGRect(x: 0, y: 0, width: 160, height: diameter + 9)
        
        let backgroundLayer = CALayer()
        backgroundLayer.contents = #imageLiteral(resourceName: "save_rect").cgImage
        backgroundLayer.frame.size = frame.size
        layer.addSublayer(backgroundLayer)
        
        let maskLayer = CALayer()
        maskLayer.contents = #imageLiteral(resourceName: "mask").cgImage
        maskLayer.frame = CGRect(x: (frame.width - diameter) / 2, y: 5, width: diameter + 1, height: diameter + 1)
        self.layer.mask = maskLayer
        
        titleView = {
            let view = UILabel()
            view.isUserInteractionEnabled = true
            view.textAlignment = .center
            view.textColor = .white
            view.attributedText = NSAttributedString(string: "SAVE".localized(), attributes: [.kern: 4])
            view.font = UIFont.dynamic(14, family: .proximaNova).bolded
            return view
        }()
        
        addSubview(titleView)
        titleView.fillSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

