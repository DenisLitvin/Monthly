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

class SubCell: ClipCell, DataBinder {
    private var disposeBag = DisposeBag()

    var titleLabel: UILabel!
    var categoryView: UIImageView!
    var iconView: UIImageView!
    var amountLabel: UILabel!
    var dateLabel: UILabel!
    private var backgroundRoundView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpLayout()
    }
    func set(data: SubCellViewModel) {
        disposeBag = DisposeBag()
        
        data.titleText
            .asDriver(onErrorJustReturn: "")
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        data.priceText
            .asDriver(onErrorJustReturn: NSAttributedString())
            .drive(amountLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        data.categoryImage
            .asDriver(onErrorJustReturn: UIImage())
            .drive(categoryView.rx.image)
            .disposed(by: disposeBag)
        
        data.dateText
            .asDriver(onErrorJustReturn: NSAttributedString())
            .drive(dateLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        data.iconImage
            .asDriver(onErrorJustReturn: UIImage())
            .drive(iconView.rx.image)
            .disposed(by: disposeBag)
    }
    
    //MARK: - PRIVATE
    private func setUpViews() {
        backgroundColor = UIColor.Theme.darkBlue
        backgroundRoundView = {
            let view = UIView()
            view.clip.enabled()
            view.backgroundColor = UIColor.Theme.grayedBlue
            view.clipsToBounds = true
            view.layer.cornerRadius = 12
            return view
        }()
        titleLabel = {
            let view = UILabel()
            view.font = UIFont.dynamic(25, family: .proximaNovaCond).bolded
            view.textColor = .white
            view.numberOfLines = 0
            view.clip.enabled()
            return view
        }()
        amountLabel = {
            let view = UILabel()
//            view.adjustsFontSizeToFitWidth = true
            view.font = UIFont.dynamic(25, family: .proximaNovaCond)
            view.textColor = .white
            view.clip.enabled()
            return view
        }()
        categoryView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
            view.clip.enabled()
            return view
        }()
        dateLabel = {
            let view = UILabel()
//            view.adjustsFontSizeToFitWidth = true
            view.font = UIFont.dynamic(12, family: .proximaNova).bolded
            view.textColor = UIColor.Theme.gray
            view.clip.enabled()
            return view
        }()
        iconView = {
            let view = UIImageView()
            //templocal
            view.clip.wantsSize = CGSize(width: 45, height: 45)
            view.clip.enabled()
            return view
        }()
    }

    private func setUpLayout() {
        clip.withDistribution(.row)

        backgroundRoundView.clip.withDistribution(.row).inset(5)
        addSubview(backgroundRoundView)

        let rowContainer = UIView()
        rowContainer.clip.enabled()
            .horizontallyAligned(.stretch)
            .withDistribution(.row)
            .insetLeft(33).insetTop(20).insetBottom(20).insetRight(33)
        backgroundRoundView.addSubview(rowContainer)
        
        rowContainer.addSubview(iconView)
        
        let midColumnContainer = UIView()
        midColumnContainer.clip.enabled()
            .withDistribution(.column)
            .insetLeft(26).insetRight(20)
        rowContainer.addSubview(midColumnContainer)
        
        titleLabel.clip.horizontallyAligned(.head).insetBottom(6).horizontallyAligned(.stretch)
        midColumnContainer.addSubview(titleLabel)
        categoryView.clip.horizontallyAligned(.head)
        midColumnContainer.addSubview(categoryView)
        
        let rightColumnContainer = UIView()
        rightColumnContainer.clip.enabled().withDistribution(.column)
        rowContainer.addSubview(rightColumnContainer)

        amountLabel.clip.horizontallyAligned(.tail).insetBottom(8)
        rightColumnContainer.addSubview(amountLabel)
        dateLabel.clip.horizontallyAligned(.tail)
        rightColumnContainer.addSubview(dateLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
