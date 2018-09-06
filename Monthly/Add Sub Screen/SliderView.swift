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

class CustomLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clip.enabled()
        textColor = UIColor.Theme.lightBlue
        font = UIFont.dynamic(12, family: .proximaNova).bolded
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTextField: UIView {
    
    var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        clipsToBounds = true
        layer.cornerRadius = 19
        backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        
        textField = {
            let view = UITextField()
            view.clip.enabled()
            view.textColor = UIColor.Theme.lightBlue
            return view
        }()
        addSubview(textField)
        
        textField.clip
            .insetLeft(10).insetRight(10)
            .verticallyAligned(.stretch).horizontallyAligned(.stretch)
        
        self.clip.enabled().withHeight(38)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SliderView: UIView {
    private let disposeBag = DisposeBag()
    
    var lineView: UIImageView!
    var iconView: UIImageView!
    var youSpendLabel: UILabel!
    var youSpendTextField: CustomTextField!
    
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
        self.addSubview(youSpendLabel)
        self.addSubview(youSpendTextField)
    }
    
    private func setUpViews() {
        lineView = UIImageView(image: #imageLiteral(resourceName: "line"))
        lineView.clip.enabled()
        
        iconView = UIImageView(image: #imageLiteral(resourceName: "icon_holder"))
        iconView.clip.enabled()
        
        youSpendLabel = CustomLabel()
        youSpendLabel.text = "YOU SPEND".localized()
        
        youSpendTextField = CustomTextField()
        youSpendTextField.clip.withWidth(90)
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
