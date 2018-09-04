//
//  UIView+roundedCorners.swift
//  Monthly
//
//  Created by Denis Litvin on 31.08.2018.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = path.cgPath
        self.layer.mask = layer
    }
}
