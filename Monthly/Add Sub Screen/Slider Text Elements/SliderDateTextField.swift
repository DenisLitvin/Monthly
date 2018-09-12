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
    private var disposeBag = DisposeBag()
    
    private var viewModel: SliderDateTextFieldViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpDatePicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        viewModel.date.onNext(datePicker.date)
    }
    
    private func setUpBindings() {
        viewModel.dateString.drive(textField.rx.text).disposed(by: disposeBag)
    }
}

extension SliderDateTextField: MVVMBinder {
    func set(viewModel: SliderDateTextFieldViewModel) {
        self.disposeBag = DisposeBag()
        self.viewModel = viewModel
        setUpBindings()
    }
}

