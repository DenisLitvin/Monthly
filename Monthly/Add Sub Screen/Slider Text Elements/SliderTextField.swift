//
//  SliderTextField.swift
//  Monthly
//
//  Created by Denis Litvin on 08.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

class SliderTextField: UIView {
    
    private weak var nextField: SliderTextField?
    private weak var previousField: SliderTextField?
    
    var textField: UITextField!
    var nextFieldButton: UIBarButtonItem!
    var previousFieldButton: UIBarButtonItem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpLayout()
        setUpSelf()
    }
    
    func next(textField: SliderTextField) {
        nextField = textField
        textField.previousField = self
        nextFieldButton.isEnabled = true
        textField.previousFieldButton.isEnabled = true
    }
    
    //MARK: PRIVATE
    private func setUpLayout() {
        self.clip.enabled().withHeight(38)
        
        textField.clip
            .insetLeft(15).insetRight(15)
            .verticallyAligned(.stretch).horizontallyAligned(.stretch)
        addSubview(textField)
    }
    
    private func setUpSelf() {
        clipsToBounds = true
        layer.cornerRadius = 19
        backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexibleSeparator = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(backTapped))
        backButton.tintColor = .white
        backButton.isEnabled = false
        self.previousFieldButton = backButton
        
        let forwardButton = UIBarButtonItem(image: #imageLiteral(resourceName: "forward"), style: .plain, target: self, action: #selector(forwardTapped))
        forwardButton.tintColor = .white
        forwardButton.isEnabled = false
        self.nextFieldButton = forwardButton

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .white
        
        toolbar.items = [backButton, forwardButton, flexibleSeparator, doneButton]
        toolbar.sizeToFit()
        self.textField.inputAccessoryView = toolbar
    }
    
    private func setUpViews() {
        textField = {
            let view = UITextField()
            view.keyboardAppearance = UIKeyboardAppearance.dark
            view.font = UIFont.dynamic(11, family: .proximaNova)
            view.textColor = UIColor.Theme.lightBlue
            view.clip.enabled()
            return view
        }()
    }
    
    @objc private func backTapped() {
        if let previous = previousField {
            previous.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    @objc private func forwardTapped() {
        if let next = nextField {
            next.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    @objc private func doneButtonTapped() {
        textField.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
