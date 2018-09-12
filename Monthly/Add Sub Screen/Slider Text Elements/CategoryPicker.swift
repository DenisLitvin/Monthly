//
//  CategoryPicker.swift
//  Monthly
//
//  Created by Denis Litvin on 11.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

class CategoryPicker: UIPickerView {
    
    let data = [
        "DAY",
        "WEEK",
        "MONTH",
        "YEAR"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
        clip.enabled().withWidth(90).withHeight(120)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CategoryPicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = (view as? SliderLabel) ?? SliderLabel()
        label.clip.enable = false
        label.textAlignment = .center
        label.attributedText = data[row].localized().attributedForSliderText()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 90
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 22
    }
    
}

extension CategoryPicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
}
