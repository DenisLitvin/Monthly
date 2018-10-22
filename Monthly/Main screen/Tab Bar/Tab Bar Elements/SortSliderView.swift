//
//  FilterSliderView.swift
//  Monthly
//
//  Created by Denis Litvin on 10/19/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import FlexLayout

import RxSwift
import RxCocoa

class SortSliderView: UIScrollView {
    var disposeBag = DisposeBag()
    
    private let contentView = UIView()
    private var sortButtons = [TabBarButton]()
    
    var sortButtonTapped = PublishSubject<Int>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpLayout()
        setUpSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - PRIVATE
    private func setUpLayout() {
        flex.addItem(contentView).direction(.row).define { (flex) in
            for button in sortButtons {
                flex.addItem(button).height(50).width(60).marginRight(10).marginLeft(10)
            }
        }
        contentView.flex.layout()
    }
    
    private func setUpViews() {
        for i in 1 ... 4 {
            let selected = UIImage(named: "\(i)_s")
            let deselected = UIImage(named: "\(i)_ds")
            let button = TabBarButton()
            button.selectedImage = selected!
            button.deselectedImage = deselected!
            button.isOn
                .filter { $0 }
                .map { _ in i }
                .bind(to: sortButtonTapped.asObserver())
                .disposed(by: disposeBag)

            sortButtons.append(button)
        }
        sortButtons.forEach { $0.concurrentButtons = sortButtons }
    }
    
    private func setUpSelf() {
        showsHorizontalScrollIndicator = true
        let size = contentView.flex.intrinsicSize
        contentView.frame.size = size
        contentSize = size
    }
}
