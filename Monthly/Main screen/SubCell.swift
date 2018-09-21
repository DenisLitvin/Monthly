//
//  SubCell.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import ClipLayout
import RxCocoa
import RxSwift

//class CategoryView: UIView {
//
//    var titleLabel: UILabel!
//    var backgroundLayer: CALayer!
//
//    init() {
//        super.init(frame: .zero)
//        clipsToBounds = true
//        layer.cornerRadius = 5
//        layer.clip.enable()
//        clip.enable().withDistribution(.row)
//
//        backgroundLayer = CAGradientLayer.Elements.cellCategory
//        backgroundLayer.clip.enable().aligned(v: .stretch, h: .stretch)
//        layer.addSublayer(backgroundLayer)
//
//        titleLabel = {
//           let view = UILabel()
//            view.clip.enable()
//            view.textColor = UIColor.Theme.blue
//            view.font = UIFont.dynamic(8, family: .proximaNova)
//            return view
//        }()
//        titleLabel.clip.insetLeft(11).insetTop(6).insetBottom(6).insetRight(9)
//        addSubview(titleLabel)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class SubCell: UICollectionViewCell, MVVMBinder {
    private var disposeBag = DisposeBag()
    
    private var backgroundRoundView: UIView!

    private var viewModel: SubCellViewModel!

    var titleLabel: UILabel!
    var categoryView: UILabel!
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: SubCellViewModel) {
        disposeBag = DisposeBag()
        self.viewModel = viewModel
        setUpBindings()
    }
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        
        viewModel.titleText.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.valueText.drive(valueLabel.rx.attributedText).disposed(by: disposeBag)
        viewModel.categoryText.drive(categoryView.rx.attributedText).disposed(by: disposeBag)
        viewModel.dateText.drive(dateLabel.rx.attributedText).disposed(by: disposeBag)
//        viewModel.iconImage.drive(iconView.rx.image).disposed(by: disposeBag)
        viewModel.bellViewIcon.drive(bellView.rx.image).disposed(by: disposeBag)
    }
    
    private func setUpLayout() {
        contentView.clip.withDistribution(.row)
        
        backgroundRoundView.clip.withDistribution(.row).insetTop(9).insetBottom(9).insetLeft(13).insetRight(13)
        contentView.addSubview(backgroundRoundView)
        
        let rowContainer = UIView()
        rowContainer.clip.enable()
            .horizontallyAligned(.stretch)
            .withDistribution(.row)
            .insetLeft(33).insetTop(20).insetBottom(20).insetRight(13)
        backgroundRoundView.addSubview(rowContainer)
        
        rowContainer.addSubview(iconView)
        
        let midColumnContainer = UIView()
        midColumnContainer.clip.enable()
            .withDistribution(.column)
            .insetLeft(26).insetRight(20)
        rowContainer.addSubview(midColumnContainer)
        
        titleLabel.clip.horizontallyAligned(.head).insetBottom(10)
        midColumnContainer.addSubview(titleLabel)
        categoryView.clip.horizontallyAligned(.head)
        midColumnContainer.addSubview(categoryView)
        
        let rightColumnContainer = UIView()
        rightColumnContainer.clip.enable().withDistribution(.column)
        rowContainer.addSubview(rightColumnContainer)
        
        valueLabel.clip.horizontallyAligned(.tail).insetBottom(10)
        rightColumnContainer.addSubview(valueLabel)
        dateLabel.clip.horizontallyAligned(.tail)
        rightColumnContainer.addSubview(dateLabel)
        
        bellView.clip.verticallyAligned(.head).insetLeft(14).insetTop(-7)
        rowContainer.addSubview(bellView)
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
            view.font = UIFont.dynamic(18, family: .proximaNova).bolded
            view.textColor = UIColor.Theme.lightBlue
            view.numberOfLines = 0
            view.clip.enable()
            return view
        }()
        valueLabel = {
            let view = UILabel()
            view.textAlignment = .right
            view.font = UIFont.dynamic(18, family: .proximaNovaCond)
            view.textColor = UIColor.Theme.lightBlue
            view.clip.enable()
            return view
        }()
        categoryView = {
            let view = UILabel()
            view.font = UIFont.dynamic(11, family: .proximaNova).bolded
            view.textColor = UIColor.Theme.slightlyGrayedBlue
            view.clip.enable()
            return view
        }()
        dateLabel = {
            let view = UILabel()
            view.textAlignment = .right
            view.font = UIFont.dynamic(9, family: .proximaNova)
            view.textColor = UIColor.Theme.grayedBlue
            view.clip.enable()
            return view
        }()
        iconView = {
            let view = UIImageView()
//            view.clip.wantsSize = CGSize(width: 33, height: 33)//templocal
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

   
}
