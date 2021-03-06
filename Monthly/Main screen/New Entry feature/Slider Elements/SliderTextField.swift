//
//  SliderTextField.swift
//  Monthly
//
//  Created by Denis Litvin on 08.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class SliderTextField: UIView {
    var disposeBag = DisposeBag()

    weak var nextField: SliderTextField?
    weak var previousField: SliderTextField?
    
    var textField: UITextField!
    var nextFieldButton: UIBarButtonItem!
    var previousFieldButton: UIBarButtonItem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpLayout()
        setUpSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    func next(textField: SliderTextField) {
        nextField = textField
        textField.previousField = self
        nextFieldButton.isEnabled = true
        textField.previousFieldButton.isEnabled = true
    }
    
    func toolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        
        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backTapped))
        backButton.tintColor = .black
        backButton.isEnabled = false
        self.previousFieldButton = backButton
        
        let forwardButton = UIBarButtonItem(image: #imageLiteral(resourceName: "forward"), style: .plain, target: self, action: #selector(forwardTapped))
        forwardButton.tintColor = .black
        forwardButton.isEnabled = false
        self.nextFieldButton = forwardButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .black
        
        toolbar.items = [backButton, forwardButton, flexibleSeparator, doneButton]
        toolbar.sizeToFit()
        return toolbar
    }
    
    //MARK: PRIVATE
    private func setUpLayout() {
        self.clip.enable().withHeight(38)
        
        textField.clip
            .insetLeft(15).insetRight(15)
            .verticallyAligned(.stretch).horizontallyAligned(.stretch)
        addSubview(textField)
    }
    
    private func setUpSelf() {
        clipsToBounds = true
        layer.cornerRadius = 19
        backgroundColor = UIColor.Elements.textFieldBackground
        self.textField.inputAccessoryView = toolBar()
    }
    
    private func setUpViews() {
        textField = {
            let view = UITextField()
            view.keyboardAppearance = UIKeyboardAppearance.light
            view.font = UIFont.dynamic(15, family: .avenir).bolded
            view.textColor = UIColor.Elements.textFieldText
            view.clip.enable()
            view.delegate = self
            return view
        }()
    }
    
    @objc private func backTapped() {
        if let previous = previousField {
            previous.becomeFirstResponder()
        } else {
            resignFirstResponder()
        }
    }
    
    @objc private func forwardTapped() {
        if let next = nextField {
            next.becomeFirstResponder()
        } else {
            resignFirstResponder()
        }
    }
    
    @objc private func doneButtonTapped() {
        resignFirstResponder()
    }
}

extension SliderTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
}
