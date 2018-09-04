//
//  NewSubView.swift
//  Monthly
//
//  Created by Denis Litvin on 26.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

import VisualEffectView

class SliderView: UIView {
    private let disposeBag = DisposeBag()
    
    var lineView: UIImageView!
    var iconView: UIImageView!
    
    init() {
        super.init(frame: .zero)
        
        setUpBindings()
        setUpSelf()
        setUpViews()
        setUplayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - PRIVATE
    private func setUplayout() {
        clip.enabled().withDistribution(.column)
        
        lineView.clip.insetTop(16.5).insetBottom(17.5)
        self.addSubview(lineView)
        self.addSubview(iconView)
    }
    
    private func setUpViews() {
        lineView = UIImageView(image: #imageLiteral(resourceName: "line"))
        lineView.clip.enabled()
        
        iconView = UIImageView(image: #imageLiteral(resourceName: "icon_holder"))
        iconView.clip.enabled()
    }
    
    private func setUpBindings() {
        
        
    }
    
    private func setUpSelf() {
        let screenSize = UIScreen.main.bounds.size
        let height = UIScreen.main.bounds.height * 0.6
        self.frame = CGRect(x: 0, y: screenSize.height - height, width: screenSize.width, height: height)
        
        backgroundColor = .clear
        clipsToBounds = true
        isHidden = true
        roundCorners(UIRectCorner.topLeft.union(UIRectCorner.topRight), radius: 35)
        
        let layer = CAGradientLayer.Elements.slider
        layer.frame.size = frame.size
        self.layer.addSublayer(layer)
        
        transform = CGAffineTransform(translationX: 0, y: frame.height)

    }
}
