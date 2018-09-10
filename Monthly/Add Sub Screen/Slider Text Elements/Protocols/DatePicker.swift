//
//  DatePicker.swift
//  Monthly
//
//  Created by Denis Litvin on 09.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

@objc
protocol DatePickerField where Self: SliderTextField {
    @objc func dateChanged(_ datePicker: UIDatePicker)
}

extension DatePickerField {
    func setUpDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        textField.inputView = datePicker
    }
}
