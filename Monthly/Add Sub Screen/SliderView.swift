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
        adjustsFontSizeToFitWidth = true
        textColor = UIColor.Theme.lightBlue
        font = UIFont.dynamic(12, family: .proximaNova).bolded
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class SliderView: UIScrollView {
    private let disposeBag = DisposeBag()
    
    private let contentView = UIView()
    
    var lineView: UIImageView!
    var iconView: UIImageView!
    var youSpendLabel: UILabel!
    var youSpendTextField: SliderTextField!
    
    init() {
        super.init(frame: .zero)
        setUpBindings()
        setUpViews()
        setUplayout()
        setUpSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Animator.stopAllAnimations(view: self)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: - PRIVATE
    
    private func setUpBindings() {
        
    }
    
    private func setUplayout() {
        self.clip.enabled()
        
        contentView.clip.enabled().withDistribution(.column)
        self.addSubview(contentView)
        
        lineView.clip.insetTop(16.5).insetBottom(17.5)
        contentView.addSubview(lineView)
        
        let paddingsContainer = UIView()
        paddingsContainer.clip.enabled().withDistribution(.column)
            .insetLeft(50).insetRight(50).insetBottom(80)
        contentView.addSubview(paddingsContainer)
        
        //main content
        let firstRow = UIView()
        firstRow.clip.enabled().withDistribution(.row)
        paddingsContainer.addSubview(firstRow)
        
        firstRow.addSubview(iconView)
        youSpendLabel.clip.insetRight(10).insetLeft(10).horizontallyAligned(.stretch)
        firstRow.addSubview(youSpendLabel)
        firstRow.addSubview(youSpendTextField)
    }
    
    private func setUpViews() {
        lineView = UIImageView(image: #imageLiteral(resourceName: "line"))
        lineView.clip.enabled()
        
        iconView = UIImageView(image: #imageLiteral(resourceName: "icon_holder"))
        iconView.clip.enabled()
        
        youSpendLabel = {
            let view = CustomLabel()
            view.textAlignment = .right
            view.attributedText = "YOU SPEND".localized().attributedForSliderText()
            return view
        }()
        youSpendTextField = {
            let view = SliderTextField()
            view.textField.keyboardType = UIKeyboardType.decimalPad
            view.textField.textAlignment = .right
            view.textField.attributedPlaceholder = "$ 0".localized().attributedForSliderPlaceholder()
            view.layer.cornerRadius = 11
            view.clip.withWidth(90)
            return view
        }()
    }
    
    private func setUpSelf() {
        let screenSize = UIScreen.main.bounds.size
        let contentHeight = contentView.clip.measureSize(within: CGSize(width: screenSize.width,
                                                                        height: .greatestFiniteMagnitude)).height
        var maxFrameHeight = screenSize.height - 70
        if #available(iOS 11.0, *) {
            maxFrameHeight -= safeAreaInsets.top
        }
        let height = min(maxFrameHeight, contentHeight)
        self.frame = CGRect(x: 0, y: screenSize.height - height, width: screenSize.width, height: height)
        self.contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
        
        clipsToBounds = false
        alwaysBounceVertical = true
        backgroundColor = .clear
        isHidden = true
        
        let layer = CAGradientLayer.Elements.slider
        layer.cornerRadius = 35
        layer.frame.size = CGSize(width: screenSize.width, height: contentHeight + screenSize.height)
        self.contentView.layer.insertSublayer(layer, at: 0)
        
        transform = CGAffineTransform(translationX: 0, y: frame.height)

    }
}
