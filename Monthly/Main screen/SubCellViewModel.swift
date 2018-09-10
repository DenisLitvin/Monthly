//
//  SubCellViewModel.swift
//  Monthly
//
//  Created by Denis Litvin on 10.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SubCellViewModel {
    private let disposeBag = DisposeBag()
    
    //INPUT
    var model: AnyObserver<Sub>!
    
    //OUTPUT
    var titleText: Driver<String>!
    var valueText: Driver<NSAttributedString>!
    var dateText: Driver<NSAttributedString>!
    var categoryText: Driver<NSAttributedString>!
    var iconImage: Driver<UIImage>!
    var bellViewIcon: Driver<UIImage>!
    
    init() {
        let modelSubject = BehaviorSubject<Sub>.init(value: Sub())
        
        model = modelSubject.asObserver()
        
        let modelObs = modelSubject.asObservable()
        
        titleText = modelObs
            .map { $0.name }
            .asDriver(onErrorJustReturn: "")
        
        
        valueText = modelObs
            .map { "\($0.amount)".attributedForAmount() }
            .asDriver(onErrorJustReturn: NSAttributedString())
        
        categoryText = modelObs
            .map { (sub: Sub) -> NSAttributedString in
                let category = Sub.Category.get(index: sub.category) ?? .daily
                return category.rawValue.attributedForCategory()
            }
        .asDriver(onErrorJustReturn: NSAttributedString())
        
        iconImage = modelObs
            .filter { $0.icon != nil }
            .map { UIImage(data: $0.icon! ) ?? UIImage() } //todo default
            .asDriver(onErrorJustReturn: UIImage())//too  default
        
        dateText = modelObs
            .map { (sub: Sub) -> NSAttributedString in
                let category = Sub.Category.get(index: sub.category) ?? .daily
                let days = PaymentPeriodCalculator.daysUntilNextPayment(firstPayment: sub.firstPayout, category: category)
                return PaymentPeriodFormatter.string(from: days).attributedForDate()
            }
            .asDriver(onErrorJustReturn: NSAttributedString())
        
        bellViewIcon = modelObs
            .map { (sub: Sub) -> UIImage in
                let toggle = sub.remind ? "on" : "off"
                return UIImage(named: "bell_\(toggle)")!
            }
            .asDriver(onErrorJustReturn: UIImage(named: "bell_off")!)
        
    }
}
