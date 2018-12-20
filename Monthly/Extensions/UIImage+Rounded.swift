//
//  UIImage+Rounded.swift
//  Monthly
//
//  Created by Denis Litvin on 11/18/18.
//  Copyright © 2018 Denis Litvin. All rights reserved.
//

import UIKit

extension UIImage {
    func rounded() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: self.size),
                                byRoundingCorners: UIRectCorner.allCorners,
                                cornerRadii: CGSize(width: 9, height: 9))
        context?.addPath(path.cgPath)
        context?.clip()
        
        self.draw(at: .zero)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image!
    }
}
