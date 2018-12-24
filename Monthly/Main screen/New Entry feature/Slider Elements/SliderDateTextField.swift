//
//  SliderDateTextField.swift
//  Monthly
//
//  Created by Denis Litvin on 09.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SliderDateTextField: SliderTextField, DatePickerField {
        
    var date: AnyObserver<Date>!
    var didChangeDate: Driver<Date>!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.adjustsFontSizeToFitWidth = true
        setUpBindings()
        setUpDatePicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        date.onNext(datePicker.date)
    }
    
    //MARK: - PRIVATE
    private func setUpBindings() {
        let didChangeDate = PublishSubject<Date>.init()
        date = didChangeDate.asObserver()
        
        self.didChangeDate = didChangeDate
            .asDriver(onErrorJustReturn: Date())
        
        self.didChangeDate
            .map { date in
                return DateFormatter.billDate.string(from: date)
            }
            .drive(textField.rx.text)
            .disposed(by: disposeBag)
    }
}

