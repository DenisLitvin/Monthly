//
//  SubCellViewModel.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import RxSwift

class SubCellViewModel {
    private let disposeBag = DisposeBag()
    
    var model = PublishSubject<Sub>.init()
    var titleText = BehaviorSubject<String>.init(value: "")
    var priceText = BehaviorSubject<NSAttributedString>.init(value: NSAttributedString())
    var dateText = BehaviorSubject<NSAttributedString>.init(value: NSAttributedString())
    var categoryImage = BehaviorSubject<UIImage>.init(value: #imageLiteral(resourceName: "category_1"))
    var iconImage = BehaviorSubject<UIImage>.init(value: UIImage())
    
    init() {
        let modelObs = model.asObserver()
        
        modelObs
            .map { $0.name }
            .bind(to: titleText)
            .disposed(by: disposeBag)
        

        modelObs
            .map { "\($0.amount)".attributedForAmount() }
            .bind(to: priceText)
            .disposed(by: disposeBag)
        
        modelObs
            .map { UIImage(named: "category_\($0.category)") ?? UIImage() }
            .bind(to: categoryImage)
            .disposed(by: disposeBag)
        
        modelObs
            .filter { $0.icon != nil }
            .map { UIImage(data: $0.icon! ) ?? UIImage() } //todo default
            .bind(to: iconImage)
            .disposed(by: disposeBag)
        
        modelObs
            .map { (sub: Sub) -> NSAttributedString in
                let category = Sub.Category(rawValue: sub.category) ?? .daily
                let days = PaymentPeriodCalculator.daysUntilNextPayment(firstPayment: sub.firstPayout, category: category)
                return PaymentPeriodFormatter.string(from: days).attributedForDate()
            }
            .bind(to: dateText)
            .disposed(by: disposeBag)
    }
}
