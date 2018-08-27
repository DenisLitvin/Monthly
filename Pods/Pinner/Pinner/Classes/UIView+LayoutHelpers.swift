//
//  UIView+LayoutHelpers.swift
//  testingAnchors
//
//  Created by macbook on 28.10.2017.
//  Copyright © 2017 macbook. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func fillSafeArea(with view: UIView){
        
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let layoutGuide = self.view.safeAreaLayoutGuide
            view.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor).isActive = true
        } else {
            view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
    }
}
extension UIView {
    
    public func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
   
    public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
}

