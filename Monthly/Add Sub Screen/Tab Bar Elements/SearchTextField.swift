//
//  SearchTextField.swift
//  Monthly
//
//  Created by Denis Litvin on 10/13/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchTextField: UITextField {
    
    let done = PublishSubject<String>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.keyboardAppearance = .dark
        self.returnKeyType = .done
        self.delegate = self
        self.textColor = .white
        let screenWidth = UIScreen.main.bounds.size.width
        let width = screenWidth * 0.61
        self.frame = CGRect(x: screenWidth * 0.24, y: 15, width: width, height: 32)
        let separator: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: 0, y: 32, width: width, height: 2)
            let path = UIBezierPath()
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
            layer.path = path.cgPath
            layer.lineWidth = 2
            layer.strokeColor = UIColor.white.cgColor
            return layer
        }()
        self.layer.addSublayer(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        done.onNext(text ?? "")
        return true
    }
}
