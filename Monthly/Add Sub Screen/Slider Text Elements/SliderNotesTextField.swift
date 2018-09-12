//
//  File.swift
//  Monthly
//
//  Created by Denis Litvin on 11.09.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SliderNotesTextField: SliderTextField {
    let disposeBag = DisposeBag()
    
    var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView = {
            let view = UITextView()
            view.textContainerInset = .zero
            view.keyboardAppearance = UIKeyboardAppearance.dark
            view.font = UIFont.dynamic(11, family: .proximaNova)
            view.textColor = UIColor.Theme.lightBlue
            view.backgroundColor = .clear
            view.clip.enabled()
            return view
        }()
        addSubview(textView)
        
        textField.isUserInteractionEnabled = false
        textField.attributedPlaceholder = "Enter some notes …"
            .localized()
            .attributedForSliderPlaceholder()
        
        clip.withHeight(80)
        textField.clip.aligned(v: .head, h: .head)
            .insetTop(12).insetLeft(12)
        textView.clip.aligned(v: .stretch, h: .stretch)
            .insetTop(12).insetLeft(9).insetBottom(12).insetRight(9)
        
        textView.rx.text.orEmpty
            .subscribe(onNext: { str in
                if str.isEmpty {
                    self.textField.isHidden = false
                }
                else {
                    self.textField.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
}
