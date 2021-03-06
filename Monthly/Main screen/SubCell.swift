//
//  SubCell.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import FlexLayout
import Pinner

import RxCocoa
import RxSwift

class CategoryView: UIView {

    var titleLabel: UILabel!
    var backgroundLayer: CALayer!

    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.clip.enable()

        backgroundLayer = CALayer()
        backgroundLayer.backgroundColor = UIColor.Elements.categoryLabelbackground.cgColor
        backgroundLayer.clip.enable()
            .aligned(v: .stretch, h: .stretch)
        layer.addSublayer(backgroundLayer)

        titleLabel = {
           let view = UILabel()
            view.textColor = .white
            view.font = UIFont.dynamic(8, family: .avenir).bolded
            return view
        }()
        
        flex.alignSelf(.start).addItem(titleLabel)
            .marginLeft(9)
            .marginTop(3)
            .marginBottom(3)
            .marginRight(7)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SubCell: UICollectionViewCell, ViewModelBindable {
    private var disposeBag = DisposeBag()
    
    private var backgroundRoundView: UIView!
    
    private var viewModel: SubCellViewModel!
    
    var titleLabel: UILabel!
    var categoryView: CategoryView!
    var iconView: UIImageView!
    var valueLabel: UILabel!
    var dateLabel: UILabel!
    var bellView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.Elements.background
        setUpViews()
        setUpLayout()
    }
    
    func set(viewModel: SubCellViewModel) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        setUpBindings()
    }
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        viewModel.titleText
            .driveAndLayout(titleLabel.rx.text, view: titleLabel, superview: self)
            .disposed(by: disposeBag)
        viewModel.valueText
            .driveAndLayout(valueLabel.rx.attributedText, view: valueLabel, superview: self)
            .disposed(by: disposeBag)
        viewModel.categoryText
            .driveAndLayout(categoryView.titleLabel.rx.attributedText, view: categoryView.titleLabel, superview: self)
            .disposed(by: disposeBag)
        viewModel.dateText
            .driveAndLayout(dateLabel.rx.attributedText, view: dateLabel, superview: self)
            .disposed(by: disposeBag)
        viewModel.iconImage.drive(iconView.rx.image).disposed(by: disposeBag)
        viewModel.bellViewIcon.drive(bellView.rx.image).disposed(by: disposeBag)
    }
    
    private func setUpLayout() {
        contentView.flex.define { (flex) in
            flex.addItem(backgroundRoundView)
                .marginTop(5).marginBottom(5).marginLeft(13).marginRight(13)
                .define { (flex) in
                    //row container
                    flex.addItem().direction(.row).alignItems(.center)
                        .marginTop(20).marginLeft(20).marginBottom(20).marginRight(13)
                        .define { (flex) in
                            flex.addItem(iconView)
                            flex.addItem().marginLeft(18).marginRight(10).grow(1).shrink(1).define { (flex) in
                                    flex.addItem(titleLabel).marginBottom(10)
                                    flex.addItem(categoryView)
                            }
                            flex.addItem().alignItems(.end).define { (flex) in
                                flex.addItem(valueLabel).marginBottom(10)
                                flex.addItem(dateLabel)
                            }
                            flex.addItem(bellView).marginLeft(14).marginRight(0).alignSelf(.start)
                    }
            }
        }
    }
    
    private func setUpViews() {
        backgroundRoundView = {
            let view = UIView()
            view.clip.enable()
            view.layer.clip.enable()
            let layer = CAGradientLayer.Elements.cellBackground
            layer.clip.enable().aligned(v: .stretch, h: .stretch)
            view.layer.addSublayer(layer)
            view.clipsToBounds = true
            view.layer.cornerRadius = 8
            return view
        }()
        titleLabel = {
            let view = UILabel()
            view.font = UIFont.dynamic(21, family: .avenirNext).bolded
            view.textColor = UIColor.Elements.labelText
            view.numberOfLines = 0
            view.clip.enable()
            return view
        }()
        valueLabel = {
            let view = UILabel()
            view.textAlignment = .right
            view.font = UIFont.dynamic(18, family: .avenirNextCondensed)
            view.textColor = UIColor.Elements.labelText
            view.clip.enable()
            return view
        }()
        categoryView = CategoryView()
        dateLabel = {
            let view = UILabel()
            view.textAlignment = .right
            view.font = UIFont.dynamic(11, family: .avenirNext)
            view.textColor = UIColor.Elements.dateLabelText
            view.clip.enable()
            return view
        }()
        iconView = {
            let view = UIImageView()
            view.flex.size(CGSize(width: 33, height: 33))
            view.contentMode = .scaleAspectFit
            view.image = #imageLiteral(resourceName: "signature")
            view.clip.enable()
            return view
        }()
        bellView = {
            let view = UIImageView()
            view.clip.enable()
            view.image = #imageLiteral(resourceName: "bell_off")
            return view
        }()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func layout(size: CGSize) {
        flex.size(size).layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout(size: CGSize(width: size.width, height: size.height))
        return CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: frame.width, height: frame.height))
    }
    
}
